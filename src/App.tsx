import { Layout } from "./components/Layout";
import { Toasts } from "./components/Toasts";
import { AppStoreProvider, useAppStore } from "./hooks/useAppStore";
import { BookingScreen } from "./pages/BookingScreen";
import { InboxPage } from "./pages/InboxPage";
import { RelationsPage } from "./pages/RelationsPage";
import { SettingsPage } from "./pages/SettingsPage";

function AppContent() {
  const { activeView } = useAppStore();

  return (
    <Layout>
      {activeView === "inbox" ? <InboxPage /> : null}
      {activeView === "relations" ? <RelationsPage /> : null}
      {activeView === "settings" ? <SettingsPage /> : null}
      {activeView === "booking" ? <BookingScreen /> : null}
      <Toasts />
    </Layout>
  );
}

export default function App() {
  return (
    <AppStoreProvider>
      <AppContent />
    </AppStoreProvider>
  );
}
