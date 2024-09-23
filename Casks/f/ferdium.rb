cask "ferdium" do
  arch arm: "arm64", intel: "x64"

  version "6.7.7"
  sha256 arm:   "f08ead1931de7e0f414fb4b2301320cfb62299733c08a870322fa56d618bdee7",
         intel: "80f7c225aa4c5841758d5bed04a7c80d150f984122ecee7b53ad77494e691f85"

  url "https:github.comferdiumferdium-appreleasesdownloadv#{version}Ferdium-mac-#{version}-#{arch}.dmg",
      verified: "github.comferdiumferdium-app"
  name "Ferdium"
  desc "Multi-platform multi-messaging app"
  homepage "https:ferdium.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "Ferdium.app"

  uninstall quit:   "com.ferdium.ferdium-app",
            delete: "LibraryLogsDiagnosticReportsFerdium Helper_.*wakeups_resource.diag"

  zap trash: [
    "~LibraryApplication SupportCachesferdium-updater",
    "~LibraryApplication SupportFerdium",
    "~LibraryCachescom.ferdium.ferdium-app",
    "~LibraryCachescom.ferdium.ferdium-app.ShipIt",
    "~LibraryLogsFerdium",
    "~LibraryPreferencesByHostcom.ferdium.ferdium-app.ShipIt.*.plist",
    "~LibraryPreferencescom.electron.ferdium.helper.plist",
    "~LibraryPreferencescom.electron.ferdium.plist",
    "~LibraryPreferencescom.ferdium.ferdium-app.plist",
    "~LibrarySaved Application Statecom.ferdium.ferdium-app.savedState",
  ]
end