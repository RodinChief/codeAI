import { AlertTriangle, CheckCircle2, Clock3, FileSearch, Loader2 } from "lucide-react";
import { Badge } from "./ui/badge";
import type { DocumentStatus } from "../types";

const statusMap: Record<DocumentStatus, { label: string; tone: "neutral" | "success" | "warning" | "danger" | "info" | "violet"; icon: typeof Clock3 }> = {
  pending: { label: "Te verwerken", tone: "neutral", icon: Clock3 },
  processing: { label: "In behandeling", tone: "info", icon: Loader2 },
  review: { label: "Ter controle", tone: "warning", icon: FileSearch },
  processed: { label: "Verwerkt", tone: "success", icon: CheckCircle2 },
  error: { label: "Fout", tone: "danger", icon: AlertTriangle },
};

export function StatusBadge({ status }: { status: DocumentStatus }) {
  const item = statusMap[status];
  const Icon = item.icon;
  return (
    <Badge tone={item.tone}>
      <Icon className="h-3.5 w-3.5" />
      {item.label}
    </Badge>
  );
}
