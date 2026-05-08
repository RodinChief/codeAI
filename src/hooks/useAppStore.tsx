import {
  createContext,
  type PropsWithChildren,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
} from "react";
import {
  administration as initialAdministration,
  appSettings as initialSettings,
  auditEvents as initialAuditEvents,
  bookingDrafts as initialDrafts,
  chatMessages as initialChatMessages,
  currentUser,
  documents as initialDocuments,
  relations as initialRelations,
  syncLogs as initialSyncLogs,
} from "../data/mockData";
import { mockAiService } from "../services/aiService";
import { mockYukiService } from "../services/yukiService";
import type {
  Administration,
  AiChatMessage,
  AppSettings,
  AuditEvent,
  BookingDraft,
  Document,
  DocumentStatus,
  Relation,
  StandardBookingTemplate,
  SyncLog,
} from "../types";

type View = "inbox" | "relations" | "settings" | "booking";

interface Toast {
  id: string;
  tone: "success" | "warning" | "error" | "info";
  message: string;
}

interface AppStore {
  administration: Administration;
  settings: AppSettings;
  documents: Document[];
  relations: Relation[];
  drafts: BookingDraft[];
  chatMessages: AiChatMessage[];
  syncLogs: SyncLog[];
  auditEvents: AuditEvent[];
  activeView: View;
  selectedDocumentId?: string;
  selectedRelationId?: string;
  isSyncing: boolean;
  toasts: Toast[];
  openView: (view: View) => void;
  openDocument: (documentId: string) => void;
  selectRelation: (relationId?: string) => void;
  updateDocumentStatus: (documentId: string, status: DocumentStatus) => void;
  updateDraft: (draft: BookingDraft) => void;
  addLine: (documentId: string) => void;
  removeLine: (documentId: string, lineId: string) => void;
  approveBooking: (documentId: string) => Promise<void>;
  saveConcept: (documentId: string) => void;
  reanalyseDocument: (documentId: string) => Promise<void>;
  sendAiChat: (documentId: string, message: string) => Promise<void>;
  saveStandardTemplate: (documentId: string) => Promise<void>;
  saveRelationInstruction: (relationId: string, text: string) => Promise<void>;
  sendBackToYuki: (documentId: string) => Promise<void>;
  syncNow: () => Promise<void>;
  testYukiConnection: () => Promise<void>;
  updateSettings: (settings: Partial<AppSettings>) => void;
  dismissToast: (id: string) => void;
}

const AppStoreContext = createContext<AppStore | null>(null);

function createToast(message: string, tone: Toast["tone"] = "info"): Toast {
  return { id: `toast-${Date.now()}-${Math.random()}`, message, tone };
}

export function AppStoreProvider({ children }: PropsWithChildren) {
  const [administration, setAdministration] = useState(initialAdministration);
  const [settings, setSettings] = useState(initialSettings);
  const [documents, setDocuments] = useState(initialDocuments);
  const [relations, setRelations] = useState(initialRelations);
  const [drafts, setDrafts] = useState(initialDrafts);
  const [chatMessages, setChatMessages] = useState(initialChatMessages);
  const [syncLogs, setSyncLogs] = useState(initialSyncLogs);
  const [auditEvents, setAuditEvents] = useState(initialAuditEvents);
  const [activeView, setActiveView] = useState<View>("inbox");
  const [selectedDocumentId, setSelectedDocumentId] = useState<string>();
  const [selectedRelationId, setSelectedRelationId] = useState<string>();
  const [isSyncing, setIsSyncing] = useState(false);
  const [toasts, setToasts] = useState<Toast[]>([]);

  const pushToast = useCallback((message: string, tone: Toast["tone"] = "info") => {
    const toast = createToast(message, tone);
    setToasts((items) => [...items, toast]);
    window.setTimeout(() => {
      setToasts((items) => items.filter((item) => item.id !== toast.id));
    }, 4200);
  }, []);

  const syncNow = useCallback(async () => {
    setIsSyncing(true);
    const pendingDocuments = await mockYukiService.fetchPendingDocuments();
    const latestRelations = await mockYukiService.fetchRelations();
    const latestLogs = await mockYukiService.fetchSyncLogs();
    const syncedAt = new Date().toISOString();
    setDocuments((current) => {
      const knownIds = new Set(current.map((document) => document.id));
      return [
        ...current,
        ...pendingDocuments.filter((document) => !knownIds.has(document.id)),
      ];
    });
    setRelations(latestRelations);
    setSyncLogs([
      {
        id: `log-sync-${Date.now()}`,
        type: "sync",
        status: "success",
        message: "Handmatige sync uitgevoerd met Yuki mock API.",
        createdAt: syncedAt,
      },
      ...latestLogs,
    ]);
    setAdministration((current) => ({ ...current, lastSyncAt: syncedAt }));
    setIsSyncing(false);
    pushToast("Yuki sync voltooid", "success");
  }, [pushToast]);

  useEffect(() => {
    const interval = window.setInterval(
      () => {
        void syncNow();
      },
      administration.syncIntervalMinutes * 60 * 1000,
    );
    return () => window.clearInterval(interval);
  }, [administration.syncIntervalMinutes, syncNow]);

  const openDocument = useCallback((documentId: string) => {
    setSelectedDocumentId(documentId);
    setActiveView("booking");
  }, []);

  const updateDocumentStatus = useCallback(
    (documentId: string, status: DocumentStatus) => {
      setDocuments((current) =>
        current.map((document) =>
          document.id === documentId
            ? {
                ...document,
                status,
                processedAt: status === "processed" ? new Date().toISOString() : document.processedAt,
                processedBy: status === "processed" ? currentUser.name : document.processedBy,
              }
            : document,
        ),
      );
      pushToast("Documentstatus bijgewerkt", "success");
    },
    [pushToast],
  );

  const updateDraft = useCallback((draft: BookingDraft) => {
    setDrafts((current) =>
      current.map((item) =>
        item.id === draft.id ? { ...draft, updatedAt: new Date().toISOString() } : item,
      ),
    );
  }, []);

  const addLine = useCallback((documentId: string) => {
    setDrafts((current) =>
      current.map((draft) =>
        draft.documentId === documentId
          ? {
              ...draft,
              lines: [
                ...draft.lines,
                {
                  id: `line-${Date.now()}`,
                  description: "Nieuwe factuurregel",
                  ledgerAccount: draft.ledgerAccount,
                  amountExVat: 0,
                },
              ],
            }
          : draft,
      ),
    );
  }, []);

  const removeLine = useCallback((documentId: string, lineId: string) => {
    setDrafts((current) =>
      current.map((draft) =>
        draft.documentId === documentId
          ? { ...draft, lines: draft.lines.filter((line) => line.id !== lineId) }
          : draft,
      ),
    );
  }, []);

  const approveBooking = useCallback(
    async (documentId: string) => {
      const draft = drafts.find((item) => item.documentId === documentId);
      if (!draft) return;
      const auditEvent = await mockYukiService.submitBookingToYuki(draft);
      setAuditEvents((current) => [auditEvent, ...current]);
      setDocuments((current) =>
        current.map((document) =>
          document.id === documentId
            ? {
                ...document,
                status: "processed",
                processedAt: new Date().toISOString(),
                processedBy: currentUser.name,
                confidence: draft.confidence,
              }
            : document,
        ),
      );
      pushToast("Boeking goedgekeurd en naar Yuki gestuurd", "success");
    },
    [drafts, pushToast],
  );

  const saveConcept = useCallback(
    (documentId: string) => {
      setDocuments((current) =>
        current.map((document) =>
          document.id === documentId ? { ...document, status: "review" } : document,
        ),
      );
      pushToast("Concept opgeslagen in Ter controle", "success");
    },
    [pushToast],
  );

  const reanalyseDocument = useCallback(
    async (documentId: string) => {
      const draft = drafts.find((item) => item.documentId === documentId);
      const relation = relations.find((item) => item.id === draft?.relationId);
      if (!draft) return;
      const suggestion = await mockAiService.createBookingProposal({
        draft,
        relation,
        relationInstructions: relation?.instructions.map((item) => item.text) ?? [],
        threshold: settings.confidenceThreshold,
      });
      setDrafts((current) =>
        current.map((item) =>
          item.documentId === documentId
            ? {
                ...item,
                confidence: suggestion.confidence,
                aiReasoning: suggestion.reasoning,
                updatedAt: new Date().toISOString(),
              }
            : item,
        ),
      );
      setDocuments((current) =>
        current.map((document) =>
          document.id === documentId
            ? {
                ...document,
                confidence: suggestion.confidence,
                status: suggestion.canAutoProcess ? "processing" : "review",
              }
            : document,
        ),
      );
      pushToast("AI-analyse opnieuw uitgevoerd", "success");
    },
    [drafts, relations, settings.confidenceThreshold, pushToast],
  );

  const sendAiChat = useCallback(
    async (documentId: string, message: string) => {
      const draft = drafts.find((item) => item.documentId === documentId);
      if (!draft) return;
      const userMessage: AiChatMessage = {
        id: `chat-user-${Date.now()}`,
        documentId,
        role: "user",
        content: message,
        createdAt: new Date().toISOString(),
      };
      setChatMessages((current) => [...current, userMessage]);
      const response = await mockAiService.applyChatInstruction(draft, message);
      updateDraft(response.draft);
      setChatMessages((current) => [...current, response.reply]);
      pushToast("AI heeft de boeking aangepast", "success");
    },
    [drafts, pushToast, updateDraft],
  );

  const saveStandardTemplate = useCallback(
    async (documentId: string) => {
      const draft = drafts.find((item) => item.documentId === documentId);
      if (!draft?.relationId) {
        pushToast("Koppel eerst een relatie voordat je een standaardboeking opslaat", "warning");
        return;
      }
      const template = await mockYukiService.saveStandardBookingTemplate(draft.relationId, {
        name: `${draft.relationName} - ${draft.ledgerAccount}`,
        documentType: draft.documentType,
        instructionText: draft.aiReasoning,
        ledgerAccounts: Array.from(new Set(draft.lines.map((line) => line.ledgerAccount))),
        vatLogic: `Gebruik ${draft.vatChoice} tenzij OCR iets anders aangeeft.`,
        lineLogic: "Gebruik de huidige factuurregels als referentie voor toekomstige voorstellen.",
        preferredPaymentMethod: draft.payment.method,
        createdBy: currentUser.name,
      });
      setRelations((current) =>
        current.map((relation) =>
          relation.id === draft.relationId
            ? {
                ...relation,
                hasStandardBooking: true,
                templates: [template, ...relation.templates],
              }
            : relation,
        ),
      );
      pushToast("Standaardboeking opgeslagen op relatiekaart", "success");
    },
    [drafts, pushToast],
  );

  const saveRelationInstruction = useCallback(
    async (relationId: string, text: string) => {
      if (!text.trim()) return;
      const instruction = await mockYukiService.saveRelationInstruction(relationId, {
        text,
        createdBy: currentUser.name,
      });
      setRelations((current) =>
        current.map((relation) =>
          relation.id === relationId
            ? { ...relation, instructions: [instruction, ...relation.instructions] }
            : relation,
        ),
      );
      pushToast("AI-instructie opgeslagen", "success");
    },
    [pushToast],
  );

  const sendBackToYuki = useCallback(
    async (documentId: string) => {
      const auditEvent = await mockYukiService.sendBackToYukiForReprocessing(documentId);
      setAuditEvents((current) => [auditEvent, ...current]);
      setDocuments((current) =>
        current.map((document) =>
          document.id === documentId ? { ...document, status: "pending" } : document,
        ),
      );
      pushToast("Document teruggezet voor Yuki-herverwerking", "warning");
    },
    [pushToast],
  );

  const testYukiConnection = useCallback(async () => {
    const result = await mockYukiService.testConnection();
    pushToast(result.message, result.ok ? "success" : "error");
  }, [pushToast]);

  const value = useMemo<AppStore>(
    () => ({
      administration,
      settings,
      documents,
      relations,
      drafts,
      chatMessages,
      syncLogs,
      auditEvents,
      activeView,
      selectedDocumentId,
      selectedRelationId,
      isSyncing,
      toasts,
      openView: setActiveView,
      openDocument,
      selectRelation: setSelectedRelationId,
      updateDocumentStatus,
      updateDraft,
      addLine,
      removeLine,
      approveBooking,
      saveConcept,
      reanalyseDocument,
      sendAiChat,
      saveStandardTemplate,
      saveRelationInstruction,
      sendBackToYuki,
      syncNow,
      testYukiConnection,
      updateSettings: (partial) => setSettings((current) => ({ ...current, ...partial })),
      dismissToast: (id) => setToasts((items) => items.filter((item) => item.id !== id)),
    }),
    [
      administration,
      settings,
      documents,
      relations,
      drafts,
      chatMessages,
      syncLogs,
      auditEvents,
      activeView,
      selectedDocumentId,
      selectedRelationId,
      isSyncing,
      toasts,
      openDocument,
      updateDocumentStatus,
      updateDraft,
      addLine,
      removeLine,
      approveBooking,
      saveConcept,
      reanalyseDocument,
      sendAiChat,
      saveStandardTemplate,
      saveRelationInstruction,
      sendBackToYuki,
      syncNow,
      testYukiConnection,
    ],
  );

  return <AppStoreContext.Provider value={value}>{children}</AppStoreContext.Provider>;
}

export function useAppStore() {
  const store = useContext(AppStoreContext);
  if (!store) {
    throw new Error("useAppStore must be used within AppStoreProvider");
  }
  return store;
}
