import { Activity, Bot, DatabaseZap, FileCog, PlugZap, ShieldCheck } from "lucide-react";
import { Badge } from "../components/ui/badge";
import { Button } from "../components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "../components/ui/card";
import { Input, Label, Select } from "../components/ui/form";
import { useAppStore } from "../hooks/useAppStore";
import { formatDateTime } from "../lib/utils";

export function SettingsPage() {
  const {
    administration,
    settings,
    syncLogs,
    auditEvents,
    updateSettings,
    testYukiConnection,
  } = useAppStore();

  return (
    <div className="space-y-6">
      <section className="glass-panel rounded-[2rem] border border-white p-6">
        <p className="mb-2 flex items-center gap-2 text-sm font-semibold text-sky-700">
          <FileCog className="h-4 w-4" />
          Configuratie
        </p>
        <h2 className="text-3xl font-bold tracking-tight text-slate-950">Instellingen</h2>
        <p className="mt-2 max-w-3xl text-sm leading-6 text-slate-600">
          Beheer de Yuki-koppeling, AI-threshold, boekingsdefaults en audit trail voor deze
          administratieomgeving.
        </p>
      </section>

      <div className="grid gap-6 xl:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <PlugZap className="h-5 w-5" />
              A. Yuki koppeling
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid gap-3 md:grid-cols-2">
              <SettingTile label="API status" value={administration.apiStatus} badge="connected" />
              <SettingTile label="Laatste sync" value={formatDateTime(administration.lastSyncAt)} />
              <SettingTile label="Administratie ID" value={administration.yukiAdministrationId} />
              <div>
                <Label>Sync interval (minuten)</Label>
                <Input value={administration.syncIntervalMinutes} disabled />
              </div>
            </div>
            <Button variant="secondary" onClick={() => void testYukiConnection()}>
              <ShieldCheck className="h-4 w-4" />
              Test verbinding
            </Button>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Bot className="h-5 w-5" />
              B. AI instellingen
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid gap-3 md:grid-cols-2">
              <div>
                <Label>Confidence threshold</Label>
                <Input
                  type="number"
                  value={settings.confidenceThreshold}
                  onChange={(event) =>
                    updateSettings({ confidenceThreshold: Number(event.target.value) })
                  }
                />
              </div>
              <div>
                <Label>Model naam</Label>
                <Input
                  value={settings.aiModelName}
                  onChange={(event) => updateSettings({ aiModelName: event.target.value })}
                />
              </div>
            </div>
            <ToggleRow
              label="Automatisch in behandeling nemen"
              checked={settings.autoTakeProcessing}
              onChange={(checked) => updateSettings({ autoTakeProcessing: checked })}
            />
            <ToggleRow
              label="Automatisch doorsturen boven threshold"
              checked={settings.autoSubmitAboveThreshold}
              onChange={(checked) => updateSettings({ autoSubmitAboveThreshold: checked })}
            />
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <DatabaseZap className="h-5 w-5" />
              C. Boekingsinstellingen
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid gap-3 md:grid-cols-3">
              <div>
                <Label>Documenttypes</Label>
                <div className="flex flex-wrap gap-2">
                  {settings.defaultDocumentTypes.map((item) => (
                    <Badge key={item} tone="info">
                      {item}
                    </Badge>
                  ))}
                </div>
              </div>
              <div>
                <Label>Betaalwijzen</Label>
                <div className="flex flex-wrap gap-2">
                  {settings.defaultPaymentMethods.map((item) => (
                    <Badge key={item} tone="neutral">
                      {item}
                    </Badge>
                  ))}
                </div>
              </div>
              <div>
                <Label>Btw-keuzes</Label>
                <div className="flex flex-wrap gap-2">
                  {settings.defaultVatChoices.map((item) => (
                    <Badge key={item} tone="violet">
                      {item}
                    </Badge>
                  ))}
                </div>
              </div>
            </div>
            <div>
              <Label>Fallback gedrag bij ontbrekende relatie</Label>
              <Select
                value={settings.missingRelationFallback}
                onChange={(event) => updateSettings({ missingRelationFallback: event.target.value })}
              >
                <option>Naar Ter controle sturen en relatie laten kiezen</option>
                <option>Terugsturen naar Yuki voor herverwerking</option>
                <option>Concept aanmaken zonder relatie</option>
              </Select>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Activity className="h-5 w-5" />
              D. Logging / audit
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="max-h-[30rem] space-y-3 overflow-y-auto pr-1 scrollbar-soft">
              {[...syncLogs, ...auditEvents.map((event) => ({
                id: event.id,
                type: "booking" as const,
                status: "success" as const,
                message: `${event.action}: ${event.details}`,
                createdAt: event.createdAt,
              }))].sort((a, b) => b.createdAt.localeCompare(a.createdAt)).map((log) => (
                <div key={log.id} className="rounded-2xl border border-slate-100 p-4">
                  <div className="mb-2 flex items-center justify-between gap-3">
                    <Badge
                      tone={
                        log.type === "sync"
                          ? "info"
                          : log.type === "ai"
                            ? "violet"
                            : log.type === "correction"
                              ? "warning"
                              : "success"
                      }
                    >
                      {log.type}
                    </Badge>
                    <span className="text-xs text-slate-400">{formatDateTime(log.createdAt)}</span>
                  </div>
                  <p className="text-sm text-slate-700">{log.message}</p>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}

function SettingTile({
  label,
  value,
  badge,
}: {
  label: string;
  value: string;
  badge?: string;
}) {
  return (
    <div className="rounded-2xl bg-slate-50 p-4 ring-1 ring-slate-200">
      <span className="mb-1 block text-xs font-semibold uppercase text-slate-500">{label}</span>
      {badge ? <Badge tone="success">{value}</Badge> : <strong className="text-slate-900">{value}</strong>}
    </div>
  );
}

function ToggleRow({
  label,
  checked,
  onChange,
}: {
  label: string;
  checked: boolean;
  onChange: (checked: boolean) => void;
}) {
  return (
    <label className="flex cursor-pointer items-center justify-between rounded-2xl bg-slate-50 p-4 ring-1 ring-slate-200">
      <span className="font-semibold text-slate-800">{label}</span>
      <input
        type="checkbox"
        checked={checked}
        onChange={(event) => onChange(event.target.checked)}
        className="h-5 w-5 accent-slate-950"
      />
    </label>
  );
}
