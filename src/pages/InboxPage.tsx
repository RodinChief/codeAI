import { ArrowDownUp, CheckCircle2, Eye, FileCheck2, FileClock, Search, SlidersHorizontal } from "lucide-react";
import { useMemo, useState } from "react";
import { ConfidenceBadge } from "../components/ConfidenceBadge";
import { StatusBadge } from "../components/StatusBadge";
import { Badge } from "../components/ui/badge";
import { Button } from "../components/ui/button";
import { Card, CardContent } from "../components/ui/card";
import { Input, Label, Select } from "../components/ui/form";
import { useAppStore } from "../hooks/useAppStore";
import { formatCurrency, formatDate } from "../lib/utils";
import type { Document, DocumentStatus, DocumentType } from "../types";

const statusTabs: Array<{ id: DocumentStatus; label: string; description: string }> = [
  {
    id: "pending",
    label: "Te verwerken",
    description: "Nieuwe documenten uit Yuki postbus.",
  },
  {
    id: "processing",
    label: "In behandeling",
    description: "AI is OCR, relatie en boekingsregels aan het controleren.",
  },
  {
    id: "review",
    label: "Ter controle",
    description: "Werkbak voor lage confidence en correcties.",
  },
  {
    id: "processed",
    label: "Verwerkt",
    description: "Succesvol teruggestuurd en geboekt in Yuki.",
  },
];

function DocumentCard({ document }: { document: Document }) {
  const { openDocument, updateDocumentStatus, approveBooking } = useAppStore();

  return (
    <Card className="group overflow-hidden transition hover:-translate-y-0.5 hover:shadow-xl hover:shadow-slate-950/10">
      <CardContent className="p-4">
        <div className="flex flex-col gap-4 xl:flex-row xl:items-center xl:justify-between">
          <div className="min-w-0 flex-1">
            <div className="mb-3 flex flex-wrap items-center gap-2">
              <StatusBadge status={document.status} />
              <ConfidenceBadge value={document.confidence} />
              <Badge tone="violet">{document.documentType}</Badge>
              {document.processingStep ? <Badge tone="info">{document.processingStep}</Badge> : null}
            </div>
            <button
              type="button"
              className="truncate text-left text-base font-bold text-slate-950 hover:text-sky-700"
              onClick={() => openDocument(document.id)}
            >
              {document.filename}
            </button>
            <div className="mt-3 grid gap-3 text-sm text-slate-600 sm:grid-cols-2 xl:grid-cols-4">
              <div>
                <span className="block text-xs font-semibold uppercase text-slate-400">Relatie</span>
                {document.relationName}
              </div>
              <div>
                <span className="block text-xs font-semibold uppercase text-slate-400">Factuur</span>
                {document.invoiceNumber}
              </div>
              <div>
                <span className="block text-xs font-semibold uppercase text-slate-400">Datum</span>
                {formatDate(document.date)}
              </div>
              <div>
                <span className="block text-xs font-semibold uppercase text-slate-400">Bedrag / btw</span>
                {formatCurrency(document.amount)} / {formatCurrency(document.vatAmount)}
              </div>
            </div>
          </div>
          <div className="flex flex-wrap gap-2 xl:justify-end">
            <Button variant="secondary" size="sm" onClick={() => openDocument(document.id)}>
              <Eye className="h-4 w-4" />
              Openen
            </Button>
            {document.status !== "processed" ? (
              <Button variant="success" size="sm" onClick={() => void approveBooking(document.id)}>
                <CheckCircle2 className="h-4 w-4" />
                Goedkeuren
              </Button>
            ) : null}
            {document.status !== "review" && document.status !== "processed" ? (
              <Button variant="warning" size="sm" onClick={() => updateDocumentStatus(document.id, "review")}>
                Naar controle
              </Button>
            ) : null}
            {document.status !== "processed" ? (
              <Button variant="ghost" size="sm" onClick={() => updateDocumentStatus(document.id, "processed")}>
                Verwerkt
              </Button>
            ) : null}
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

export function InboxPage() {
  const { documents } = useAppStore();
  const [activeStatus, setActiveStatus] = useState<DocumentStatus>("review");
  const [query, setQuery] = useState("");
  const [documentType, setDocumentType] = useState<"all" | DocumentType>("all");
  const [relation, setRelation] = useState("all");
  const [confidence, setConfidence] = useState("all");
  const [sort, setSort] = useState("newest");

  const relations = Array.from(new Set(documents.map((document) => document.relationName))).sort();

  const filteredDocuments = useMemo(() => {
    return documents
      .filter((document) => document.status === activeStatus)
      .filter((document) => {
        const haystack = [
          document.filename,
          document.relationName,
          document.invoiceNumber,
          document.documentType,
          document.status,
        ]
          .join(" ")
          .toLowerCase();
        return haystack.includes(query.toLowerCase());
      })
      .filter((document) => documentType === "all" || document.documentType === documentType)
      .filter((document) => relation === "all" || document.relationName === relation)
      .filter((document) => {
        if (confidence === "low") return document.confidence <= 90;
        if (confidence === "high") return document.confidence > 90;
        return true;
      })
      .sort((a, b) => {
        if (sort === "oldest") return a.date.localeCompare(b.date);
        if (sort === "confidence") return a.confidence - b.confidence;
        if (sort === "amount") return b.amount - a.amount;
        return b.date.localeCompare(a.date);
      });
  }, [activeStatus, confidence, documentType, documents, query, relation, sort]);

  return (
    <div className="space-y-6">
      <section className="glass-panel rounded-[2rem] border border-white p-6">
        <div className="flex flex-col gap-4 xl:flex-row xl:items-end xl:justify-between">
          <div>
            <p className="mb-2 flex items-center gap-2 text-sm font-semibold text-sky-700">
              <FileClock className="h-4 w-4" />
              Slimme documentverwerking
            </p>
            <h2 className="text-3xl font-bold tracking-tight text-slate-950">Inbox</h2>
            <p className="mt-2 max-w-3xl text-sm leading-6 text-slate-600">
              Documenten stromen binnen vanuit Yuki, worden door AI geanalyseerd en blijven bij
              lage confidence veilig in de controlebak.
            </p>
          </div>
          <div className="grid grid-cols-2 gap-3 md:grid-cols-4">
            {statusTabs.map((tab) => {
              const count = documents.filter((document) => document.status === tab.id).length;
              return (
                <button
                  key={tab.id}
                  type="button"
                  onClick={() => setActiveStatus(tab.id)}
                  className={`rounded-2xl border p-4 text-left transition ${
                    activeStatus === tab.id
                      ? "border-slate-950 bg-slate-950 text-white shadow-xl"
                      : "border-slate-200 bg-white text-slate-700 hover:border-slate-300"
                  }`}
                >
                  <span className="text-2xl font-bold">{count}</span>
                  <span className="mt-1 block text-sm font-semibold">{tab.label}</span>
                </button>
              );
            })}
          </div>
        </div>
      </section>

      <Card>
        <CardContent className="space-y-4">
          <div className="flex items-center gap-2 text-sm font-semibold text-slate-700">
            <SlidersHorizontal className="h-4 w-4" />
            Filters en sortering
          </div>
          <div className="grid gap-3 md:grid-cols-2 xl:grid-cols-6">
            <div className="xl:col-span-2">
              <Label>Zoeken</Label>
              <div className="relative">
                <Search className="pointer-events-none absolute left-3 top-3 h-4 w-4 text-slate-400" />
                <Input className="pl-9" value={query} onChange={(event) => setQuery(event.target.value)} placeholder="Bestand, relatie, factuurnummer..." />
              </div>
            </div>
            <div>
              <Label>Documenttype</Label>
              <Select value={documentType} onChange={(event) => setDocumentType(event.target.value as "all" | DocumentType)}>
                <option value="all">Alle types</option>
                <option value="Inkoop">Inkoop</option>
                <option value="Verkoop">Verkoop</option>
                <option value="Kasstaat">Kasstaat</option>
              </Select>
            </div>
            <div>
              <Label>Relatie</Label>
              <Select value={relation} onChange={(event) => setRelation(event.target.value)}>
                <option value="all">Alle relaties</option>
                {relations.map((name) => (
                  <option key={name} value={name}>
                    {name}
                  </option>
                ))}
              </Select>
            </div>
            <div>
              <Label>Confidence</Label>
              <Select value={confidence} onChange={(event) => setConfidence(event.target.value)}>
                <option value="all">Alle scores</option>
                <option value="low">90% of lager</option>
                <option value="high">Boven 90%</option>
              </Select>
            </div>
            <div>
              <Label>Sortering</Label>
              <Select value={sort} onChange={(event) => setSort(event.target.value)}>
                <option value="newest">Nieuwste eerst</option>
                <option value="oldest">Oudste eerst</option>
                <option value="confidence">Laagste confidence</option>
                <option value="amount">Hoogste bedrag</option>
              </Select>
            </div>
          </div>
        </CardContent>
      </Card>

      <section className="space-y-3">
        <div className="flex items-center justify-between">
          <div>
            <h3 className="text-lg font-bold text-slate-950">
              {statusTabs.find((tab) => tab.id === activeStatus)?.label}
            </h3>
            <p className="text-sm text-slate-500">
              {statusTabs.find((tab) => tab.id === activeStatus)?.description}
            </p>
          </div>
          <Badge tone="neutral">
            <ArrowDownUp className="h-3.5 w-3.5" />
            {filteredDocuments.length} documenten
          </Badge>
        </div>
        {filteredDocuments.length ? (
          filteredDocuments.map((document) => <DocumentCard key={document.id} document={document} />)
        ) : (
          <Card className="border-dashed">
            <CardContent className="flex min-h-56 flex-col items-center justify-center text-center">
              <FileCheck2 className="mb-4 h-10 w-10 text-slate-300" />
              <h4 className="font-semibold text-slate-950">Geen documenten gevonden</h4>
              <p className="mt-1 text-sm text-slate-500">
                Pas je filters aan of start een handmatige Yuki sync.
              </p>
            </CardContent>
          </Card>
        )}
      </section>
    </div>
  );
}
