import {
  Bot,
  Building2,
  FileStack,
  RefreshCw,
  Settings,
  ShieldCheck,
  Sparkles,
} from "lucide-react";
import type { ReactNode } from "react";
import { useAppStore } from "../hooks/useAppStore";
import { formatDateTime } from "../lib/utils";
import { Badge } from "./ui/badge";
import { Button } from "./ui/button";

const navItems = [
  { id: "inbox", label: "Inbox", icon: FileStack },
  { id: "relations", label: "Relaties", icon: Building2 },
  { id: "settings", label: "Instellingen", icon: Settings },
] as const;

export function Layout({ children }: { children: ReactNode }) {
  const { activeView, openView, administration, documents, syncNow, isSyncing } = useAppStore();
  const reviewCount = documents.filter((document) => document.status === "review").length;

  return (
    <div className="min-h-screen bg-[radial-gradient(circle_at_top_left,#dbeafe,transparent_34rem),linear-gradient(180deg,#f8fafc_0%,#eef2f7_100%)]">
      <aside className="fixed inset-y-0 left-0 z-30 hidden w-72 border-r border-white/70 bg-slate-950 text-white shadow-2xl shadow-slate-950/20 lg:block">
        <div className="flex h-full flex-col p-5">
          <div className="mb-8 flex items-center gap-3">
            <div className="flex h-12 w-12 items-center justify-center rounded-2xl bg-white text-slate-950">
              <Bot className="h-6 w-6" />
            </div>
            <div>
              <p className="text-sm font-semibold text-slate-300">Yuki AI Layer</p>
              <h1 className="text-lg font-bold">Boekingsassistent</h1>
            </div>
          </div>

          <div className="mb-5 rounded-3xl border border-white/10 bg-white/5 p-4">
            <div className="mb-3 flex items-center justify-between">
              <span className="text-xs font-semibold uppercase tracking-wide text-slate-400">
                Administratie
              </span>
              <ShieldCheck className="h-4 w-4 text-emerald-300" />
            </div>
            <p className="font-semibold">{administration.name}</p>
            <p className="mt-1 text-xs text-slate-400">{administration.yukiAdministrationId}</p>
          </div>

          <nav className="space-y-2">
            {navItems.map((item) => {
              const Icon = item.icon;
              const isActive = activeView === item.id || (activeView === "booking" && item.id === "inbox");
              return (
                <button
                  key={item.id}
                  type="button"
                  onClick={() => openView(item.id)}
                  className={`flex w-full items-center justify-between rounded-2xl px-4 py-3 text-sm font-semibold transition ${
                    isActive
                      ? "bg-white text-slate-950 shadow-lg"
                      : "text-slate-300 hover:bg-white/10 hover:text-white"
                  }`}
                >
                  <span className="flex items-center gap-3">
                    <Icon className="h-5 w-5" />
                    {item.label}
                  </span>
                  {item.id === "inbox" && reviewCount > 0 ? (
                    <span className="rounded-full bg-amber-400 px-2 py-0.5 text-xs text-slate-950">
                      {reviewCount}
                    </span>
                  ) : null}
                </button>
              );
            })}
          </nav>

          <div className="mt-auto rounded-3xl border border-sky-300/20 bg-sky-400/10 p-4">
            <div className="mb-2 flex items-center gap-2 text-sky-100">
              <Sparkles className="h-4 w-4" />
              <span className="text-sm font-semibold">AI confidence flow</span>
            </div>
            <p className="text-xs leading-5 text-slate-300">
              Documenten boven de threshold worden klaargezet; alles eronder blijft veilig in Ter
              controle.
            </p>
          </div>
        </div>
      </aside>

      <div className="lg:pl-72">
        <header className="sticky top-0 z-20 border-b border-white/70 bg-white/80 px-4 py-3 backdrop-blur-xl md:px-8">
          <div className="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
            <div>
              <div className="flex flex-wrap items-center gap-2">
                <Badge tone="success">API {administration.apiStatus}</Badge>
                <Badge tone="info">Sync iedere {administration.syncIntervalMinutes} min</Badge>
              </div>
              <p className="mt-1 text-sm text-slate-500">
                Laatste sync: {formatDateTime(administration.lastSyncAt)}
              </p>
            </div>
            <div className="flex items-center gap-2">
              <Button variant="secondary" onClick={() => void syncNow()} disabled={isSyncing}>
                <RefreshCw className={`h-4 w-4 ${isSyncing ? "animate-spin" : ""}`} />
                Handmatige sync
              </Button>
              <Button variant="primary" onClick={() => openView("inbox")}>
                Open werkbak
              </Button>
            </div>
          </div>
          <div className="mt-3 flex gap-2 overflow-x-auto lg:hidden">
            {navItems.map((item) => (
              <Button
                key={item.id}
                size="sm"
                variant={activeView === item.id ? "primary" : "secondary"}
                onClick={() => openView(item.id)}
              >
                {item.label}
              </Button>
            ))}
          </div>
        </header>
        <main className="px-4 py-6 md:px-8">{children}</main>
      </div>
    </div>
  );
}
