import { Badge } from "./ui/badge";
import { confidenceTone } from "../lib/utils";

export function ConfidenceBadge({ value }: { value: number }) {
  const tone = confidenceTone(value);
  return <Badge tone={tone}>{value}% confidence</Badge>;
}
