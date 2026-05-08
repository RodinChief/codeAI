import { ChevronLeft, ChevronRight, FileText, Maximize2, Minus, Plus, ScanLine } from "lucide-react";
import { useState } from "react";
import type { Document } from "../types";
import { Badge } from "./ui/badge";
import { Button } from "./ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";

export function FileViewer({ document }: { document: Document }) {
  const [zoom, setZoom] = useState(100);
  const [page, setPage] = useState(1);

  return (
    <Card className="overflow-hidden">
      <CardHeader className="flex flex-row items-center justify-between gap-3">
        <div>
          <CardTitle className="flex items-center gap-2">
            <FileText className="h-4 w-4" />
            Document viewer
          </CardTitle>
          <p className="mt-1 truncate text-sm text-slate-500">{document.filename}</p>
        </div>
        <Badge tone="info">{document.fileType.toUpperCase()}</Badge>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="flex flex-wrap items-center justify-between gap-2 rounded-2xl bg-slate-50 p-2">
          <div className="flex items-center gap-1">
            <Button
              variant="ghost"
              size="icon"
              onClick={() => setPage((current) => Math.max(1, current - 1))}
              aria-label="Vorige pagina"
            >
              <ChevronLeft className="h-4 w-4" />
            </Button>
            <span className="px-2 text-sm font-semibold text-slate-600">
              Pagina {page}/{document.pageCount}
            </span>
            <Button
              variant="ghost"
              size="icon"
              onClick={() => setPage((current) => Math.min(document.pageCount, current + 1))}
              aria-label="Volgende pagina"
            >
              <ChevronRight className="h-4 w-4" />
            </Button>
          </div>
          <div className="flex items-center gap-1">
            <Button
              variant="ghost"
              size="icon"
              onClick={() => setZoom((current) => Math.max(70, current - 10))}
              aria-label="Uitzoomen"
            >
              <Minus className="h-4 w-4" />
            </Button>
            <span className="w-12 text-center text-sm font-semibold">{zoom}%</span>
            <Button
              variant="ghost"
              size="icon"
              onClick={() => setZoom((current) => Math.min(150, current + 10))}
              aria-label="Inzoomen"
            >
              <Plus className="h-4 w-4" />
            </Button>
            <Button variant="ghost" size="icon" aria-label="Volledig scherm">
              <Maximize2 className="h-4 w-4" />
            </Button>
          </div>
        </div>

        <div className="min-h-[520px] overflow-auto rounded-3xl bg-slate-900 p-6 scrollbar-soft">
          <div
            className="mx-auto origin-top rounded-2xl bg-white p-8 shadow-2xl transition"
            style={{ width: 420, transform: `scale(${zoom / 100})` }}
          >
            <div className="mb-8 flex items-start justify-between border-b border-slate-200 pb-4">
              <div>
                <p className="text-xs font-semibold uppercase tracking-wide text-slate-400">
                  Factuur
                </p>
                <h3 className="mt-1 text-xl font-bold text-slate-950">{document.relationName}</h3>
              </div>
              <div className="text-right text-sm text-slate-500">
                <p>{document.invoiceNumber}</p>
                <p>{document.date}</p>
              </div>
            </div>
            <div className="space-y-4 text-sm text-slate-700">
              <div className="rounded-xl bg-sky-50 p-3 ring-2 ring-sky-200">
                <p className="flex items-center gap-2 font-semibold text-sky-900">
                  <ScanLine className="h-4 w-4" />
                  AI highlight: relatie en factuurnummer herkend
                </p>
              </div>
              <div className="grid grid-cols-[1fr_auto] gap-3">
                <span>Omschrijving</span>
                <span>Bedrag</span>
                <span className="border-t border-slate-100 pt-3">Boekingsbasis</span>
                <span className="border-t border-slate-100 pt-3">
                  EUR {(document.amount - document.vatAmount).toFixed(2)}
                </span>
                <span>Btw</span>
                <span>EUR {document.vatAmount.toFixed(2)}</span>
                <strong className="border-t border-slate-200 pt-3">Totaal</strong>
                <strong className="border-t border-slate-200 pt-3">
                  EUR {document.amount.toFixed(2)}
                </strong>
              </div>
              <div className="mt-8 rounded-xl border border-dashed border-slate-300 p-4 text-center text-xs text-slate-400">
                Placeholder voor echte PDF/image rendering en OCR overlays.
              </div>
            </div>
          </div>
        </div>

        <div className="grid gap-2 text-xs text-slate-500 sm:grid-cols-3">
          {Object.entries(document.metadata).map(([key, value]) => (
            <div key={key} className="rounded-2xl bg-slate-50 p-3">
              <span className="block font-semibold uppercase text-slate-400">{key}</span>
              {value}
            </div>
          ))}
        </div>
      </CardContent>
    </Card>
  );
}
