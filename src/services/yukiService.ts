import { administration, documents, relations, syncLogs } from "../data/mockData";
import type {
  Administration,
  AuditEvent,
  BookingDraft,
  Document,
  Relation,
  RelationInstruction,
  StandardBookingTemplate,
  SyncLog,
} from "../types";
import { wait } from "../lib/utils";

export interface YukiService {
  fetchAdministration(): Promise<Administration>;
  fetchPendingDocuments(): Promise<Document[]>;
  fetchRelations(): Promise<Relation[]>;
  fetchRelationDetails(relationId: string): Promise<Relation | undefined>;
  submitBookingToYuki(draft: BookingDraft): Promise<AuditEvent>;
  sendBackToYukiForReprocessing(documentId: string): Promise<AuditEvent>;
  saveRelationInstruction(
    relationId: string,
    instruction: Omit<RelationInstruction, "id" | "relationId" | "createdAt">,
  ): Promise<RelationInstruction>;
  saveStandardBookingTemplate(
    relationId: string,
    template: Omit<StandardBookingTemplate, "id" | "relationId" | "createdAt" | "usageCount">,
  ): Promise<StandardBookingTemplate>;
  fetchSyncLogs(): Promise<SyncLog[]>;
  testConnection(): Promise<{ ok: boolean; message: string }>;
}

export const mockYukiService: YukiService = {
  async fetchAdministration() {
    await wait();
    return administration;
  },

  async fetchPendingDocuments() {
    await wait();
    return documents.filter((document) => document.status !== "processed");
  },

  async fetchRelations() {
    await wait();
    return relations;
  },

  async fetchRelationDetails(relationId) {
    await wait();
    return relations.find((relation) => relation.id === relationId);
  },

  async submitBookingToYuki(draft) {
    await wait(520);
    return {
      id: `audit-submit-${draft.documentId}-${Date.now()}`,
      documentId: draft.documentId,
      relationId: draft.relationId,
      actor: "Anne de Vries",
      action: "Boeking verstuurd naar Yuki",
      details: `${draft.reference} geboekt op ${draft.ledgerAccount}.`,
      createdAt: new Date().toISOString(),
    };
  },

  async sendBackToYukiForReprocessing(documentId) {
    await wait(420);
    return {
      id: `audit-reprocess-${documentId}-${Date.now()}`,
      documentId,
      actor: "Anne de Vries",
      action: "Teruggestuurd naar Yuki",
      details: "Document gemarkeerd voor herverwerking in Yuki.",
      createdAt: new Date().toISOString(),
    };
  },

  async saveRelationInstruction(relationId, instruction) {
    await wait(280);
    return {
      id: `instruction-${Date.now()}`,
      relationId,
      text: instruction.text,
      createdBy: instruction.createdBy,
      createdAt: new Date().toISOString(),
    };
  },

  async saveStandardBookingTemplate(relationId, template) {
    await wait(360);
    return {
      id: `template-${Date.now()}`,
      relationId,
      ...template,
      usageCount: 0,
      createdAt: new Date().toISOString(),
    };
  },

  async fetchSyncLogs() {
    await wait();
    return syncLogs;
  },

  async testConnection() {
    await wait(520);
    return {
      ok: true,
      message: "Yuki API bereikbaar. Laatste ping 122 ms.",
    };
  },
};
