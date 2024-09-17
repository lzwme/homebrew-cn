cask "yaak" do
  arch arm: "aarch64", intel: "x64"

  version "2024.9.0"
  sha256 arm:   "195bfe6d6d80311e3d81b29c8366cd571efa31057b603206639f63015395c46e",
         intel: "0cda068d2992e1289b434bebb9d20fd14f0c0a40bb77e558c8c15464344ff1e0"

  url "https:github.comyaakappappreleasesdownloadv#{version}Yaak_#{version}_#{arch}.dmg",
      verified: "github.comyaakappapp"
  name "Yaak"
  desc "REST, GraphQL and gRPC client"
  homepage "https:yaak.app"

  livecheck do
    url "https:yaak.appdownload"
    regex(href=.*?yaak[._-]v?(\d+(?:\.\d+)+)[._-]#{arch}\.dmgi)
  end

  depends_on macos: ">= :high_sierra"

  app "yaak.app"

  zap trash: [
    "~LibraryApplication Supportapp.yaak.desktop",
    "~LibraryCachesapp.yaak.desktop",
    "~LibraryLogsapp.yaak.desktop",
    "~LibrarySaved Application Stateapp.yaak.desktop.savedState",
    "~LibraryWebkitapp.yaak.desktop",
  ]
end