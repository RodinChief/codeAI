# Yuki AI Boekingsassistent

Moderne React + TypeScript prototype-app voor een AI-laag bovenop Yuki. De app bevat een werkende
mock frontend voor documentinbox, relatiebeheer, boekingscontrole, AI-chat, Yuki-sync en instellingen.

## Stack

- React + TypeScript + Vite
- Tailwind CSS
- shadcn/ui-geinspireerde component primitives
- Mock Yuki service layer en mock AI service layer

## Scripts

```bash
npm install
npm run dev
npm run build
```

## Architectuur

- `src/types.ts` bevat de frontend datamodellen.
- `src/data/mockData.ts` bevat realistische Nederlandse voorbeeldrecords.
- `src/services/yukiService.ts` bevat de Yuki integratie-abstractie.
- `src/services/aiService.ts` bevat de AI voorstel- en chatlogica.
- `src/hooks/useAppStore.tsx` bevat centrale state, polling en acties.
- `src/pages` bevat Inbox, Relaties, Instellingen en Boekingsscherm.
