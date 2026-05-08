export type DocumentStatus =
  | "pending"
  | "processing"
  | "review"
  | "processed"
  | "error";

export type RelationType = "creditor" | "debtor";

export type DocumentType = "Inkoop" | "Verkoop" | "Kasstaat";

export type PaymentMethod =
  | "Overschrijving"
  | "Incasso"
  | "Pinpas"
  | "Creditcard"
  | "Uit prive"
  | "Kas";

export type VatChoice = "9%" | "21%" | "niet aftrekbaar" | "voorbelasting";

export interface Administration {
  id: string;
  name: string;
  yukiAdministrationId: string;
  lastSyncAt: string;
  syncIntervalMinutes: number;
  apiStatus: "connected" | "warning" | "offline";
}

export interface User {
  id: string;
  name: string;
  role: string;
  avatarUrl?: string;
}

export interface BookingLine {
  id: string;
  description: string;
  ledgerAccount: string;
  amountExVat: number;
}

export interface PaymentInfo {
  method: PaymentMethod;
  iban?: string;
  bic?: string;
  warning?: string;
}

export interface RelationInstruction {
  id: string;
  relationId: string;
  text: string;
  createdAt: string;
  createdBy: string;
}

export interface StandardBookingTemplate {
  id: string;
  relationId: string;
  name: string;
  documentType: DocumentType;
  instructionText: string;
  ledgerAccounts: string[];
  vatLogic: string;
  lineLogic: string;
  preferredPaymentMethod: PaymentMethod;
  createdAt: string;
  createdBy: string;
  usageCount: number;
}

export interface Relation {
  id: string;
  name: string;
  type: RelationType;
  confidence: number;
  bookingCount: number;
  lastBookingDate: string;
  hasStandardBooking: boolean;
  address: string;
  kvk: string;
  iban?: string;
  bic?: string;
  vatNumber: string;
  postalCode: string;
  city: string;
  website: string;
  country: string;
  instructions: RelationInstruction[];
  templates: StandardBookingTemplate[];
}

export interface AiSuggestion {
  documentType: DocumentType;
  relationId?: string;
  relationName: string;
  confidence: number;
  reference: string;
  invoiceAmount: number;
  vatAmount: number;
  vatChoice: VatChoice;
  ledgerAccount: string;
  subject: string;
  lines: BookingLine[];
  payment: PaymentInfo;
  reasoning: string;
  canAutoProcess: boolean;
  sources: string[];
}

export interface BookingDraft {
  id: string;
  documentId: string;
  documentType: DocumentType;
  relationId?: string;
  relationName: string;
  address: string;
  kvk: string;
  vatNumber: string;
  postalCode: string;
  city: string;
  website: string;
  country: string;
  reference: string;
  invoiceAmount: number;
  vatAmount: number;
  vatChoice: VatChoice;
  ledgerAccount: string;
  subject: string;
  lines: BookingLine[];
  payment: PaymentInfo;
  confidence: number;
  aiReasoning: string;
  updatedAt: string;
}

export interface AiChatMessage {
  id: string;
  documentId: string;
  role: "user" | "assistant";
  content: string;
  createdAt: string;
}

export interface Document {
  id: string;
  filename: string;
  documentType: DocumentType;
  relationId?: string;
  relationName: string;
  invoiceNumber: string;
  date: string;
  amount: number;
  vatAmount: number;
  confidence: number;
  status: DocumentStatus;
  processingStep?: string;
  processedAt?: string;
  processedBy?: string;
  fileType: "pdf" | "image";
  pageCount: number;
  metadata: Record<string, string>;
  aiSuggestion: AiSuggestion;
}

export interface SyncLog {
  id: string;
  type: "sync" | "ai" | "booking" | "correction";
  status: "success" | "warning" | "error";
  message: string;
  createdAt: string;
}

export interface AuditEvent {
  id: string;
  documentId?: string;
  relationId?: string;
  actor: string;
  action: string;
  details: string;
  createdAt: string;
}

export interface AppSettings {
  confidenceThreshold: number;
  aiModelName: string;
  autoTakeProcessing: boolean;
  autoSubmitAboveThreshold: boolean;
  defaultDocumentTypes: DocumentType[];
  defaultPaymentMethods: PaymentMethod[];
  defaultVatChoices: VatChoice[];
  missingRelationFallback: string;
}
