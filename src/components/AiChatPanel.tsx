import { Bot, SendHorizonal, Sparkles, UserRound } from "lucide-react";
import { useState } from "react";
import { useAppStore } from "../hooks/useAppStore";
import { formatDateTime } from "../lib/utils";
import type { Document } from "../types";
import { Badge } from "./ui/badge";
import { Button } from "./ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Textarea } from "./ui/form";

const examples = [
  "Boek deze voortaan op kantoorbenodigdheden",
  "Splits deze factuur in 2 regels",
  "Gebruik 21% btw",
  "Dit is geen leverancier maar kasstaat",
];

export function AiChatPanel({ document }: { document: Document }) {
  const { chatMessages, sendAiChat } = useAppStore();
  const [message, setMessage] = useState("");
  const messages = chatMessages.filter((item) => item.documentId === document.id);

  const submit = () => {
    if (!message.trim()) return;
    void sendAiChat(document.id, message);
    setMessage("");
  };

  return (
    <Card className="overflow-hidden">
      <CardHeader className="bg-slate-950 text-white">
        <CardTitle className="flex items-center gap-2 text-white">
          <Bot className="h-5 w-5" />
          AI chat en uitleg
        </CardTitle>
        <p className="mt-1 text-sm text-slate-300">
          Geef instructies; de mock AI past velden realtime aan.
        </p>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="rounded-2xl bg-sky-50 p-4 text-sm text-sky-900 ring-1 ring-sky-100">
          <p className="mb-2 flex items-center gap-2 font-semibold">
            <Sparkles className="h-4 w-4" />
            Waarom dit voorstel?
          </p>
          <p>{document.aiSuggestion.reasoning}</p>
          <div className="mt-3 flex flex-wrap gap-2">
            {document.aiSuggestion.sources.map((source) => (
              <Badge key={source} tone="info">
                {source}
              </Badge>
            ))}
          </div>
        </div>

        <div className="max-h-72 space-y-3 overflow-y-auto pr-1 scrollbar-soft">
          {messages.length ? (
            messages.map((item) => {
              const Icon = item.role === "assistant" ? Bot : UserRound;
              return (
                <div
                  key={item.id}
                  className={`flex gap-3 ${item.role === "user" ? "justify-end" : "justify-start"}`}
                >
                  {item.role === "assistant" ? (
                    <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-slate-950 text-white">
                      <Icon className="h-4 w-4" />
                    </div>
                  ) : null}
                  <div
                    className={`max-w-[82%] rounded-2xl p-3 text-sm ${
                      item.role === "user"
                        ? "bg-sky-600 text-white"
                        : "bg-slate-100 text-slate-700"
                    }`}
                  >
                    <p>{item.content}</p>
                    <p className={`mt-1 text-[10px] ${item.role === "user" ? "text-sky-100" : "text-slate-400"}`}>
                      {formatDateTime(item.createdAt)}
                    </p>
                  </div>
                </div>
              );
            })
          ) : (
            <div className="rounded-2xl border border-dashed border-slate-200 p-6 text-center text-sm text-slate-500">
              Nog geen chatgeschiedenis voor dit document.
            </div>
          )}
        </div>

        <div className="flex flex-wrap gap-2">
          {examples.map((example) => (
            <button
              key={example}
              type="button"
              onClick={() => setMessage(example)}
              className="rounded-full bg-slate-100 px-3 py-1.5 text-xs font-semibold text-slate-600 hover:bg-slate-200"
            >
              {example}
            </button>
          ))}
        </div>

        <div className="space-y-2">
          <Textarea
            placeholder="Typ een correctie of instructie voor AI..."
            value={message}
            onChange={(event) => setMessage(event.target.value)}
            onKeyDown={(event) => {
              if (event.key === "Enter" && (event.metaKey || event.ctrlKey)) submit();
            }}
          />
          <Button className="w-full" onClick={submit}>
            <SendHorizonal className="h-4 w-4" />
            Verstuur instructie
          </Button>
        </div>
      </CardContent>
    </Card>
  );
}
