cask "ferdium" do
  arch arm: "arm64", intel: "x64"

  version "6.7.4"
  sha256 arm:   "5585465229a6dec1fdfe1f70399de3e431773a4640c800125778939de5c78544",
         intel: "db6ec564a4698c89b1fc527e7392ae5edb994f96064c93af0345208f1960db97"

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