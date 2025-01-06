cask "ferdium" do
  arch arm: "arm64", intel: "x64"

  version "7.0.0"
  sha256 arm:   "92f597e74cb8a56e1e723c21b1e50e15a8a6175d0ca821e30b5addd1fddd09d1",
         intel: "c65b169c2c26a39ca757ad3c421be53747ad4fe9cd7858446f0896b5e3ac8a6e"

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