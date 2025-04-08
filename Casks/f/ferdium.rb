cask "ferdium" do
  arch arm: "arm64", intel: "x64"

  version "7.0.1"
  sha256 arm:   "610e1115c49ac5ece15b221752f0199f425fe337a45b262548ae7584a032b033",
         intel: "c54f9731317bdeda3b14199366046eaed28be7b402ec9dff5787ede9f184a270"

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
  depends_on macos: ">= :big_sur"

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