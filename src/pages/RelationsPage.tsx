import { BookTemplate, Building2, ChevronRight, Info, Lightbulb, Plus, Search, ShieldCheck } from "lucide-react";
import { useMemo, useState } from "react";
import { ConfidenceBadge } from "../components/ConfidenceBadge";
import { Badge } from "../components/ui/badge";
import { Button } from "../components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "../components/ui/card";
import { Input, Label, Textarea } from "../components/ui/form";
import { useAppStore } from "../hooks/useAppStore";
import { formatDate } from "../lib/utils";
import type { RelationType } from "../types";

export function RelationsPage() {
  const { relations, selectedRelationId, selectRelation, saveRelationInstruction } = useAppStore();
  const [type, setType] = useState<RelationType>("creditor");
  const [query, setQuery] = useState("");
  const [detailTab, setDetailTab] = useState<"master" | "templates" | "instructions">("master");
  const [instruction, setInstruction] = useState("");

  const filteredRelations = useMemo(
    () =>
      relations.filter(
        (relation) =>
          relation.type === type && relation.name.toLowerCase().includes(query.toLowerCase()),
      ),
    [query, relations, type],
  );
  const selectedRelation =
    relations.find((relation) => relation.id === selectedRelationId) ?? filteredRelations[0];

  return (
    <div className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_440px]">
      <section className="space-y-5">
        <div className="glass-panel rounded-[2rem] border border-white p-6">
          <div className="flex flex-col gap-4 md:flex-row md:items-end md:justify-between">
            <div>
              <p className="mb-2 flex items-center gap-2 text-sm font-semibold text-sky-700">
                <Building2 className="h-4 w-4" />
                Yuki relaties
              </p>
              <h2 className="text-3xl font-bold tracking-tight text-slate-950">Relaties</h2>
              <p className="mt-2 text-sm leading-6 text-slate-600">
                Read-only stamgegevens uit Yuki, aangevuld met AI-instructies en standaardboekingen.
              </p>
            </div>
            <div className="flex rounded-2xl bg-white p-1 shadow-sm ring-1 ring-slate-200">
              <button
                type="button"
                onClick={() => setType("creditor")}
                className={`rounded-xl px-4 py-2 text-sm font-semibold ${
                  type === "creditor" ? "bg-slate-950 text-white" : "text-slate-600"
                }`}
              >
                Crediteuren
              </button>
              <button
                type="button"
                onClick={() => setType("debtor")}
                className={`rounded-xl px-4 py-2 text-sm font-semibold ${
                  type === "debtor" ? "bg-slate-950 text-white" : "text-slate-600"
                }`}
              >
                Debiteuren
              </button>
            </div>
          </div>
        </div>

        <Card>
          <CardContent>
            <Label>Zoeken op relatie</Label>
            <div className="relative">
              <Search className="pointer-events-none absolute left-3 top-3 h-4 w-4 text-slate-400" />
              <Input
                className="pl-9"
                placeholder="Mediterranee, Tankpas, Nova..."
                value={query}
                onChange={(event) => setQuery(event.target.value)}
              />
            </div>
          </CardContent>
        </Card>

        <Card className="overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full min-w-[780px] text-left text-sm">
              <thead className="bg-slate-50 text-xs uppercase tracking-wide text-slate-500">
                <tr>
                  <th className="px-5 py-4">Naam relatie</th>
                  <th className="px-5 py-4">Type</th>
                  <th className="px-5 py-4">Confidence</th>
                  <th className="px-5 py-4">Boekingen</th>
                  <th className="px-5 py-4">Laatste boeking</th>
                  <th className="px-5 py-4">Standaardboeking</th>
                  <th className="px-5 py-4"></th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {filteredRelations.map((relation) => (
                  <tr
                    key={relation.id}
                    className={`cursor-pointer bg-white transition hover:bg-slate-50 ${
                      selectedRelation?.id === relation.id ? "bg-sky-50/60" : ""
                    }`}
                    onClick={() => selectRelation(relation.id)}
                  >
                    <td className="px-5 py-4 font-semibold text-slate-950">{relation.name}</td>
                    <td className="px-5 py-4">
                      <Badge tone={relation.type === "creditor" ? "info" : "violet"}>
                        {relation.type === "creditor" ? "Crediteur" : "Debiteur"}
                      </Badge>
                    </td>
                    <td className="px-5 py-4">
                      <ConfidenceBadge value={relation.confidence} />
                    </td>
                    <td className="px-5 py-4 text-slate-600">{relation.bookingCount}</td>
                    <td className="px-5 py-4 text-slate-600">{formatDate(relation.lastBookingDate)}</td>
                    <td className="px-5 py-4">
                      <Badge tone={relation.hasStandardBooking ? "success" : "neutral"}>
                        {relation.hasStandardBooking ? "Ja" : "Nee"}
                      </Badge>
                    </td>
                    <td className="px-5 py-4">
                      <ChevronRight className="h-4 w-4 text-slate-400" />
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </Card>
      </section>

      <aside className="xl:sticky xl:top-28 xl:self-start">
        {selectedRelation ? (
          <Card className="overflow-hidden">
            <CardHeader className="bg-slate-950 text-white">
              <div className="flex items-start justify-between gap-3">
                <div>
                  <CardTitle className="text-white">{selectedRelation.name}</CardTitle>
                  <p className="mt-1 text-sm text-slate-300">
                    {selectedRelation.type === "creditor" ? "Crediteur" : "Debiteur"} uit Yuki
                  </p>
                </div>
                <ShieldCheck className="h-5 w-5 text-emerald-300" />
              </div>
              <div className="mt-4 flex gap-2">
                {[
                  ["master", "Stamgegevens"],
                  ["templates", "Standaard boekingen"],
                  ["instructions", "AI instructies"],
                ].map(([id, label]) => (
                  <button
                    key={id}
                    type="button"
                    onClick={() => setDetailTab(id as typeof detailTab)}
                    className={`rounded-xl px-3 py-2 text-xs font-semibold ${
                      detailTab === id ? "bg-white text-slate-950" : "bg-white/10 text-slate-200"
                    }`}
                  >
                    {label}
                  </button>
                ))}
              </div>
            </CardHeader>
            <CardContent className="max-h-[calc(100vh-15rem)] overflow-y-auto scrollbar-soft">
              {detailTab === "master" ? (
                <div className="space-y-3">
                  <div className="rounded-2xl bg-slate-50 p-4 text-sm text-slate-600">
                    <p className="mb-2 flex items-center gap-2 font-semibold text-slate-900">
                      <Info className="h-4 w-4" />
                      Read-only uit Yuki
                    </p>
                    Stamgegevens zijn bewust niet bewerkbaar in deze AI-laag.
                  </div>
                  {[
                    ["Adres", selectedRelation.address],
                    ["KVK", selectedRelation.kvk],
                    ["IBAN", selectedRelation.iban ?? "Niet bekend"],
                    ["BIC", selectedRelation.bic ?? "Niet bekend"],
                    ["Btw-nummer", selectedRelation.vatNumber],
                    ["Postcode", selectedRelation.postalCode],
                    ["Stad", selectedRelation.city],
                    ["Website", selectedRelation.website],
                    ["Land", selectedRelation.country],
                  ].map(([label, value]) => (
                    <div key={label} className="rounded-2xl border border-slate-100 p-3">
                      <span className="block text-xs font-semibold uppercase text-slate-400">{label}</span>
                      <span className="text-sm font-medium text-slate-800">{value}</span>
                    </div>
                  ))}
                </div>
              ) : null}

              {detailTab === "templates" ? (
                <div className="space-y-3">
                  {selectedRelation.templates.length ? (
                    selectedRelation.templates.map((template) => (
                      <div key={template.id} className="rounded-2xl border border-slate-200 p-4">
                        <div className="mb-3 flex items-start justify-between gap-2">
                          <div>
                            <h4 className="font-semibold text-slate-950">{template.name}</h4>
                            <p className="text-xs text-slate-500">
                              Aangemaakt door {template.createdBy} op {formatDate(template.createdAt)}
                            </p>
                          </div>
                          <Badge tone="success">{template.usageCount}x gebruikt</Badge>
                        </div>
                        <p className="mb-3 text-sm text-slate-600">{template.instructionText}</p>
                        <dl className="space-y-2 text-sm">
                          <div>
                            <dt className="font-semibold text-slate-500">Grootboek</dt>
                            <dd>{template.ledgerAccounts.join(", ")}</dd>
                          </div>
                          <div>
                            <dt className="font-semibold text-slate-500">Btw logica</dt>
                            <dd>{template.vatLogic}</dd>
                          </div>
                          <div>
                            <dt className="font-semibold text-slate-500">Factuurregels</dt>
                            <dd>{template.lineLogic}</dd>
                          </div>
                          <div>
                            <dt className="font-semibold text-slate-500">Betaalwijze</dt>
                            <dd>{template.preferredPaymentMethod}</dd>
                          </div>
                        </dl>
                      </div>
                    ))
                  ) : (
                    <div className="rounded-2xl border border-dashed border-slate-200 p-6 text-center">
                      <BookTemplate className="mx-auto mb-3 h-8 w-8 text-slate-300" />
                      <p className="font-semibold text-slate-900">Nog geen standaardboeking</p>
                      <p className="mt-1 text-sm text-slate-500">
                        Sla vanuit het boekingsscherm een gecontroleerde boeking op.
                      </p>
                    </div>
                  )}
                </div>
              ) : null}

              {detailTab === "instructions" ? (
                <div className="space-y-4">
                  <div className="rounded-2xl bg-amber-50 p-4 text-sm text-amber-800 ring-1 ring-amber-200">
                    <p className="flex items-center gap-2 font-semibold">
                      <Lightbulb className="h-4 w-4" />
                      AI-geheugen per relatie
                    </p>
                    <p className="mt-1">Deze instructies worden meegenomen bij elk voorstel.</p>
                  </div>
                  <div>
                    <Label>Nieuwe instructie</Label>
                    <Textarea
                      placeholder="Bijvoorbeeld: Boek brandstof altijd op autokosten..."
                      value={instruction}
                      onChange={(event) => setInstruction(event.target.value)}
                    />
                    <Button
                      className="mt-2"
                      variant="secondary"
                      onClick={() => {
                        void saveRelationInstruction(selectedRelation.id, instruction);
                        setInstruction("");
                      }}
                    >
                      <Plus className="h-4 w-4" />
                      Instructie opslaan
                    </Button>
                  </div>
                  {selectedRelation.instructions.map((item) => (
                    <div key={item.id} className="rounded-2xl border border-slate-200 p-4">
                      <p className="text-sm text-slate-700">{item.text}</p>
                      <p className="mt-2 text-xs text-slate-400">
                        {item.createdBy} - {formatDate(item.createdAt)}
                      </p>
                    </div>
                  ))}
                </div>
              ) : null}
            </CardContent>
          </Card>
        ) : null}
      </aside>
    </div>
  );
}
