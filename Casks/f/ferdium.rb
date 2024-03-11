cask "ferdium" do
  arch arm: "arm64", intel: "x64"

  version "6.7.1"
  sha256 arm:   "4cda4332ce252d78563f361fa2f954c8629487c441c5d5c73342cb4dd5c04de8",
         intel: "523d9fbebdc37dd5694640bbb5e6af5ee5659191152871d7001b0998a935b54a"

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