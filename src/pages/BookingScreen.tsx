import {
  ArrowLeft,
  BookmarkPlus,
  CheckCircle2,
  CircleAlert,
  FilePenLine,
  Plus,
  RefreshCw,
  RotateCcw,
  Save,
  Trash2,
} from "lucide-react";
import { useMemo } from "react";
import { AiChatPanel } from "../components/AiChatPanel";
import { ConfidenceBadge } from "../components/ConfidenceBadge";
import { FileViewer } from "../components/FileViewer";
import { StatusBadge } from "../components/StatusBadge";
import { Badge } from "../components/ui/badge";
import { Button } from "../components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "../components/ui/card";
import { Input, Label, Select, Textarea } from "../components/ui/form";
import { useAppStore } from "../hooks/useAppStore";
import { formatCurrency } from "../lib/utils";
import type { BookingDraft, DocumentType, PaymentMethod, VatChoice } from "../types";

function updateDraftField<K extends keyof BookingDraft>(
  draft: BookingDraft,
  key: K,
  value: BookingDraft[K],
) {
  return { ...draft, [key]: value };
}

export function BookingScreen() {
  const {
    selectedDocumentId,
    documents,
    drafts,
    relations,
    openView,
    updateDraft,
    addLine,
    removeLine,
    approveBooking,
    saveConcept,
    reanalyseDocument,
    saveStandardTemplate,
    sendBackToYuki,
    updateDocumentStatus,
  } = useAppStore();

  const document = documents.find((item) => item.id === selectedDocumentId) ?? documents[0];
  const draft = drafts.find((item) => item.documentId === document?.id);

  const totals = useMemo(() => {
    const exVat = draft?.lines.reduce((sum, line) => sum + Number(line.amountExVat || 0), 0) ?? 0;
    const invoiceExVat = (draft?.invoiceAmount ?? 0) - (draft?.vatAmount ?? 0);
    return {
      exVat,
      invoiceExVat,
      delta: Number((exVat - invoiceExVat).toFixed(2)),
    };
  }, [draft]);

  if (!document || !draft) {
    return (
      <Card>
        <CardContent className="flex min-h-80 flex-col items-center justify-center text-center">
          <CircleAlert className="mb-3 h-10 w-10 text-slate-300" />
          <h2 className="font-bold text-slate-950">Geen document geselecteerd</h2>
          <Button className="mt-4" onClick={() => openView("inbox")}>
            Terug naar Inbox
          </Button>
        </CardContent>
      </Card>
    );
  }

  const relation = relations.find((item) => item.id === draft.relationId);
  const update = (next: BookingDraft) => updateDraft(next);

  return (
    <div className="space-y-5">
      <section className="sticky top-[88px] z-10 rounded-3xl border border-white bg-white/90 p-3 shadow-xl shadow-slate-950/5 backdrop-blur-xl">
        <div className="flex flex-col gap-3 xl:flex-row xl:items-center xl:justify-between">
          <div className="flex min-w-0 items-center gap-3">
            <Button variant="ghost" size="icon" onClick={() => openView("inbox")} aria-label="Terug">
              <ArrowLeft className="h-5 w-5" />
            </Button>
            <div className="min-w-0">
              <div className="mb-1 flex flex-wrap items-center gap-2">
                <StatusBadge status={document.status} />
                <ConfidenceBadge value={draft.confidence} />
                <Badge tone={draft.confidence > 90 ? "success" : "warning"}>
                  threshold controle
                </Badge>
              </div>
              <h2 className="truncate text-xl font-bold text-slate-950">{document.filename}</h2>
            </div>
          </div>
          <div className="flex flex-wrap gap-2">
            <Button variant="secondary" onClick={() => saveConcept(document.id)}>
              <Save className="h-4 w-4" />
              Opslaan concept
            </Button>
            <Button variant="success" onClick={() => void approveBooking(document.id)}>
              <CheckCircle2 className="h-4 w-4" />
              Goedkeuren en naar Yuki
            </Button>
            <Button variant="secondary" onClick={() => updateDocumentStatus(document.id, "review")}>
              Naar ter controle
            </Button>
            <Button variant="secondary" onClick={() => void reanalyseDocument(document.id)}>
              <RefreshCw className="h-4 w-4" />
              AI opnieuw
            </Button>
            <Button variant="secondary" onClick={() => void saveStandardTemplate(document.id)}>
              <BookmarkPlus className="h-4 w-4" />
              Standaard opslaan
            </Button>
            <Button variant="ghost" onClick={() => void sendBackToYuki(document.id)}>
              <RotateCcw className="h-4 w-4" />
              Terug naar Yuki
            </Button>
          </div>
        </div>
      </section>

      <div className="grid gap-6 2xl:grid-cols-[minmax(0,1fr)_520px]">
        <div className="space-y-5">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <FilePenLine className="h-5 w-5" />
                Boekingsvoorstel
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-6">
              <section>
                <h3 className="mb-3 text-sm font-bold uppercase tracking-wide text-slate-500">
                  1. Type document
                </h3>
                <div className="grid gap-3 md:grid-cols-3">
                  <div>
                    <Label>Documenttype</Label>
                    <Select
                      value={draft.documentType}
                      onChange={(event) =>
                        update(updateDraftField(draft, "documentType", event.target.value as DocumentType))
                      }
                    >
                      <option>Inkoop</option>
                      <option>Verkoop</option>
                      <option>Kasstaat</option>
                    </Select>
                  </div>
                </div>
              </section>

              <section>
                <h3 className="mb-3 text-sm font-bold uppercase tracking-wide text-slate-500">
                  2. Leverancier / relatiegegevens
                </h3>
                <div className="grid gap-3 md:grid-cols-2 xl:grid-cols-3">
                  <div className="xl:col-span-2">
                    <Label>Relatie uit Yuki</Label>
                    <Select
                      value={draft.relationId ?? ""}
                      onChange={(event) => {
                        const nextRelation = relations.find((item) => item.id === event.target.value);
                        update({
                          ...draft,
                          relationId: nextRelation?.id,
                          relationName: nextRelation?.name ?? "",
                          address: nextRelation?.address ?? "",
                          kvk: nextRelation?.kvk ?? "",
                          vatNumber: nextRelation?.vatNumber ?? "",
                          postalCode: nextRelation?.postalCode ?? "",
                          city: nextRelation?.city ?? "",
                          website: nextRelation?.website ?? "",
                          country: nextRelation?.country ?? "Nederland",
                          payment: {
                            ...draft.payment,
                            iban: nextRelation?.iban,
                            bic: nextRelation?.bic,
                            warning: nextRelation?.iban ? undefined : "Geen IBAN/BIC bekend voor deze relatie.",
                          },
                        });
                      }}
                    >
                      <option value="">Kies relatie...</option>
                      {relations.map((item) => (
                        <option key={item.id} value={item.id}>
                          {item.name}
                        </option>
                      ))}
                    </Select>
                  </div>
                  <ReadOnlyField label="Adres" value={draft.address} />
                  <ReadOnlyField label="KVK" value={draft.kvk} />
                  <ReadOnlyField label="Btw-nummer" value={draft.vatNumber} />
                  <ReadOnlyField label="Postcode" value={draft.postalCode} />
                  <ReadOnlyField label="Stad" value={draft.city} />
                  <ReadOnlyField label="Website" value={draft.website} />
                  <ReadOnlyField label="Land" value={draft.country} />
                </div>
              </section>

              <section>
                <h3 className="mb-3 text-sm font-bold uppercase tracking-wide text-slate-500">
                  3. Factuurgegevens
                </h3>
                <div className="grid gap-3 md:grid-cols-2 xl:grid-cols-3">
                  <EditableField label="Referentie" value={draft.reference} onChange={(value) => update(updateDraftField(draft, "reference", value))} />
                  <NumberField label="Factuurbedrag" value={draft.invoiceAmount} onChange={(value) => update(updateDraftField(draft, "invoiceAmount", value))} />
                  <NumberField label="Factuur btw bedrag" value={draft.vatAmount} onChange={(value) => update(updateDraftField(draft, "vatAmount", value))} />
                  <div>
                    <Label>Btw keuze</Label>
                    <Select
                      value={draft.vatChoice}
                      onChange={(event) => update(updateDraftField(draft, "vatChoice", event.target.value as VatChoice))}
                    >
                      <option>9%</option>
                      <option>21%</option>
                      <option>niet aftrekbaar</option>
                      <option>voorbelasting</option>
                    </Select>
                  </div>
                  <EditableField label="Grootboekrekening (leidend)" value={draft.ledgerAccount} onChange={(value) => update(updateDraftField(draft, "ledgerAccount", value))} />
                  <EditableField label="Onderwerp" value={draft.subject} onChange={(value) => update(updateDraftField(draft, "subject", value))} />
                </div>
              </section>

              <section>
                <div className="mb-3 flex items-center justify-between gap-3">
                  <h3 className="text-sm font-bold uppercase tracking-wide text-slate-500">
                    4. Factuurregels
                  </h3>
                  <Button variant="secondary" size="sm" onClick={() => addLine(document.id)}>
                    <Plus className="h-4 w-4" />
                    Regel toevoegen
                  </Button>
                </div>
                <div className="overflow-x-auto rounded-2xl border border-slate-200">
                  <table className="w-full min-w-[720px] text-left text-sm">
                    <thead className="bg-slate-50 text-xs uppercase text-slate-500">
                      <tr>
                        <th className="px-4 py-3">Omschrijving</th>
                        <th className="px-4 py-3">Grootboekrekening</th>
                        <th className="px-4 py-3">Bedrag excl. btw</th>
                        <th className="px-4 py-3"></th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-slate-100">
                      {draft.lines.map((line) => (
                        <tr key={line.id}>
                          <td className="px-3 py-3">
                            <Input
                              value={line.description}
                              onChange={(event) =>
                                update({
                                  ...draft,
                                  lines: draft.lines.map((item) =>
                                    item.id === line.id ? { ...item, description: event.target.value } : item,
                                  ),
                                })
                              }
                            />
                          </td>
                          <td className="px-3 py-3">
                            <Input
                              value={line.ledgerAccount}
                              onChange={(event) =>
                                update({
                                  ...draft,
                                  lines: draft.lines.map((item) =>
                                    item.id === line.id ? { ...item, ledgerAccount: event.target.value } : item,
                                  ),
                                })
                              }
                            />
                          </td>
                          <td className="px-3 py-3">
                            <Input
                              type="number"
                              value={line.amountExVat}
                              onChange={(event) =>
                                update({
                                  ...draft,
                                  lines: draft.lines.map((item) =>
                                    item.id === line.id
                                      ? { ...item, amountExVat: Number(event.target.value) }
                                      : item,
                                  ),
                                })
                              }
                            />
                          </td>
                          <td className="px-3 py-3">
                            <Button
                              variant="ghost"
                              size="icon"
                              onClick={() => removeLine(document.id, line.id)}
                              aria-label="Regel verwijderen"
                            >
                              <Trash2 className="h-4 w-4" />
                            </Button>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
                <div className="mt-3 grid gap-3 md:grid-cols-3">
                  <SummaryTile label="Totaal excl. btw regels" value={formatCurrency(totals.exVat)} />
                  <SummaryTile label="Factuur excl. btw" value={formatCurrency(totals.invoiceExVat)} />
                  <div
                    className={`rounded-2xl p-4 ring-1 ${
                      Math.abs(totals.delta) <= 0.05
                        ? "bg-emerald-50 text-emerald-800 ring-emerald-200"
                        : "bg-amber-50 text-amber-800 ring-amber-200"
                    }`}
                  >
                    <span className="block text-xs font-semibold uppercase">Validatie</span>
                    <strong>
                      {Math.abs(totals.delta) <= 0.05
                        ? "Totaal sluit logisch aan"
                        : `Verschil ${formatCurrency(totals.delta)}`}
                    </strong>
                  </div>
                </div>
              </section>

              <section>
                <h3 className="mb-3 text-sm font-bold uppercase tracking-wide text-slate-500">
                  5. Betaling
                </h3>
                <div className="grid gap-3 md:grid-cols-3">
                  <div>
                    <Label>Betaalwijze</Label>
                    <Select
                      value={draft.payment.method}
                      onChange={(event) =>
                        update({
                          ...draft,
                          payment: { ...draft.payment, method: event.target.value as PaymentMethod },
                        })
                      }
                    >
                      <option>Overschrijving</option>
                      <option>Incasso</option>
                      <option>Pinpas</option>
                      <option>Creditcard</option>
                      <option>Uit prive</option>
                      <option>Kas</option>
                    </Select>
                  </div>
                  <EditableField
                    label="Bankrekening: RELATIE-REKENING"
                    value={draft.payment.iban ?? ""}
                    onChange={(value) => update({ ...draft, payment: { ...draft.payment, iban: value } })}
                  />
                  <EditableField
                    label="BIC-code"
                    value={draft.payment.bic ?? ""}
                    onChange={(value) => update({ ...draft, payment: { ...draft.payment, bic: value } })}
                  />
                </div>
                {draft.payment.warning ? (
                  <div className="mt-3 rounded-2xl bg-amber-50 p-4 text-sm text-amber-800 ring-1 ring-amber-200">
                    {draft.payment.warning}
                  </div>
                ) : null}
              </section>

              <section>
                <h3 className="mb-3 text-sm font-bold uppercase tracking-wide text-slate-500">
                  AI toelichting
                </h3>
                <Textarea
                  value={draft.aiReasoning}
                  onChange={(event) => update(updateDraftField(draft, "aiReasoning", event.target.value))}
                />
                {relation?.templates.length ? (
                  <div className="mt-3 rounded-2xl bg-emerald-50 p-4 text-sm text-emerald-800 ring-1 ring-emerald-200">
                    Standaardboeking beschikbaar voor {relation.name}: {relation.templates[0].name}
                  </div>
                ) : null}
              </section>
            </CardContent>
          </Card>
        </div>

        <aside className="space-y-5">
          <FileViewer document={document} />
          <AiChatPanel document={document} />
        </aside>
      </div>
    </div>
  );
}

function ReadOnlyField({ label, value }: { label: string; value: string }) {
  return (
    <div>
      <Label>{label}</Label>
      <Input value={value || "Niet bekend"} disabled />
    </div>
  );
}

function EditableField({
  label,
  value,
  onChange,
}: {
  label: string;
  value: string;
  onChange: (value: string) => void;
}) {
  return (
    <div>
      <Label>{label}</Label>
      <Input value={value} onChange={(event) => onChange(event.target.value)} />
    </div>
  );
}

function NumberField({
  label,
  value,
  onChange,
}: {
  label: string;
  value: number;
  onChange: (value: number) => void;
}) {
  return (
    <div>
      <Label>{label}</Label>
      <Input type="number" value={value} onChange={(event) => onChange(Number(event.target.value))} />
    </div>
  );
}

function SummaryTile({ label, value }: { label: string; value: string }) {
  return (
    <div className="rounded-2xl bg-slate-50 p-4 ring-1 ring-slate-200">
      <span className="block text-xs font-semibold uppercase text-slate-500">{label}</span>
      <strong className="text-slate-950">{value}</strong>
    </div>
  );
}
