import { AlertCircle, CheckCircle2, Info, X, Zap } from "lucide-react";
import { useAppStore } from "../hooks/useAppStore";
import { cn } from "../lib/utils";

const icons = {
  success: CheckCircle2,
  warning: Zap,
  error: AlertCircle,
  info: Info,
};

export function Toasts() {
  const { toasts, dismissToast } = useAppStore();

  return (
    <div className="fixed right-4 top-4 z-50 flex w-[calc(100vw-2rem)] max-w-sm flex-col gap-3">
      {toasts.map((toast) => {
        const Icon = icons[toast.tone];
        return (
          <div
            key={toast.id}
            className={cn(
              "flex items-start gap-3 rounded-2xl border bg-white p-4 text-sm shadow-2xl shadow-slate-950/10",
              toast.tone === "success" && "border-emerald-200",
              toast.tone === "warning" && "border-amber-200",
              toast.tone === "error" && "border-rose-200",
              toast.tone === "info" && "border-sky-200",
            )}
          >
            <Icon className="mt-0.5 h-4 w-4 shrink-0 text-slate-700" />
            <p className="flex-1 font-medium text-slate-800">{toast.message}</p>
            <button
              type="button"
              className="rounded-lg p-1 text-slate-400 hover:bg-slate-100 hover:text-slate-700"
              onClick={() => dismissToast(toast.id)}
              aria-label="Melding sluiten"
            >
              <X className="h-4 w-4" />
            </button>
          </div>
        );
      })}
    </div>
  );
}
