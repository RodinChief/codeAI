import type { AiChatMessage, AiSuggestion, BookingDraft, Relation } from "../types";
import { wait } from "../lib/utils";

export interface CreateBookingProposalInput {
  documentText?: string;
  relation?: Relation;
  draft: BookingDraft;
  relationInstructions: string[];
  threshold: number;
}

export interface AiService {
  createBookingProposal(input: CreateBookingProposalInput): Promise<AiSuggestion>;
  applyChatInstruction(
    draft: BookingDraft,
    message: string,
  ): Promise<{ draft: BookingDraft; reply: AiChatMessage }>;
}

function inferLedgerFromMessage(message: string, currentLedger: string) {
  const normalized = message.toLowerCase();
  if (normalized.includes("kantoor")) return "4400 Kantoorbenodigdheden";
  if (normalized.includes("brandstof") || normalized.includes("auto")) {
    return "4580 Autokosten brandstof";
  }
  if (normalized.includes("communicatie") || normalized.includes("telefoon")) {
    return "4620 Communicatiekosten";
  }
  if (normalized.includes("software") || normalized.includes("hosting")) {
    return "4700 Software en hosting";
  }
  if (normalized.includes("transport") || normalized.includes("koerier")) {
    return "4440 Transportkosten";
  }
  return currentLedger;
}

export const mockAiService: AiService = {
  async createBookingProposal({ draft, relation, relationInstructions, threshold }) {
    await wait(620);
    const confidenceBoost = relation?.hasStandardBooking ? 8 : 3;
    const confidence = Math.min(99, draft.confidence + confidenceBoost);
    return {
      documentType: draft.documentType,
      relationId: draft.relationId,
      relationName: draft.relationName,
      confidence,
      reference: draft.reference,
      invoiceAmount: draft.invoiceAmount,
      vatAmount: draft.vatAmount,
      vatChoice: draft.vatChoice,
      ledgerAccount: draft.ledgerAccount,
      subject: draft.subject,
      lines: draft.lines,
      payment: draft.payment,
      reasoning: [
        "Nieuwe analyse uitgevoerd met OCR, relatiegegevens en gebruikerscorrecties.",
        relation?.hasStandardBooking
          ? "Er is een standaardboeking gevonden en als primaire referentie gebruikt."
          : "Geen standaardboeking gevonden; voorstel blijft conservatief.",
        relationInstructions.length
          ? `Meegenomen instructies: ${relationInstructions.join(" ")}`
          : "Geen relatie-instructies beschikbaar.",
      ].join(" "),
      canAutoProcess: confidence > threshold,
      sources: [
        "Documentinhoud OCR / extractie",
        "Relatieherkenning",
        "Yuki relatiegegevens",
        "Standaardboekingen",
        "AI instructies",
        "Eerdere correcties",
      ],
    };
  },

  async applyChatInstruction(draft, message) {
    await wait(420);
    const ledgerAccount = inferLedgerFromMessage(message, draft.ledgerAccount);
    const lowerMessage = message.toLowerCase();
    const vatChoice = lowerMessage.includes("9%")
      ? "9%"
      : lowerMessage.includes("niet aftrekbaar")
        ? "niet aftrekbaar"
        : lowerMessage.includes("voorbelasting")
          ? "voorbelasting"
          : lowerMessage.includes("21%")
            ? "21%"
            : draft.vatChoice;
    const shouldSplit = lowerMessage.includes("splits") || lowerMessage.includes("2 regels");
    const nextDraft: BookingDraft = {
      ...draft,
      vatChoice,
      ledgerAccount,
      lines: shouldSplit
        ? [
            {
              id: `line-chat-${Date.now()}-1`,
              description: "Kosten hoofdactiviteit",
              ledgerAccount,
              amountExVat: Number(((draft.invoiceAmount - draft.vatAmount) * 0.7).toFixed(2)),
            },
            {
              id: `line-chat-${Date.now()}-2`,
              description: "Aanvullende kosten",
              ledgerAccount:
                ledgerAccount === "4530 Representatiekosten"
                  ? "4420 Vergaderkosten"
                  : draft.ledgerAccount,
              amountExVat: Number(((draft.invoiceAmount - draft.vatAmount) * 0.3).toFixed(2)),
            },
          ]
        : draft.lines.map((line) => ({ ...line, ledgerAccount })),
      aiReasoning: `Aangepast op basis van chatinstructie: "${message}".`,
      confidence: Math.min(99, draft.confidence + 4),
      updatedAt: new Date().toISOString(),
    };

    return {
      draft: nextDraft,
      reply: {
        id: `chat-ai-${Date.now()}`,
        documentId: draft.documentId,
        role: "assistant",
        content: `Ik heb de boeking bijgewerkt. Grootboek staat nu op ${ledgerAccount} en btw-keuze op ${vatChoice}.`,
        createdAt: new Date().toISOString(),
      },
    };
  },
};
