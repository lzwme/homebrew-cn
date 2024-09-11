cask "zen-browser" do
  arch arm: "aarch64", intel: "x64"

  version "1.0.0-a.39"
  sha256 arm:   "9e637193ef722ffab3491a7fe9a2a1725c562d8ee21bea38df08dc5d90067cb0",
         intel: "19df7b246926537808f1d78534e305893bb0d4505e0c5a303a58efeaa930a3b4"

  url "https:github.comzen-browserdesktopreleasesdownload#{version}zen.macos-#{arch}.dmg",
      verified: "github.comzen-browserdesktop"
  name "Zen Browser"
  desc "Gecko based web browser"
  homepage "https:zen-browser.app"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Zen Browser.app"

  zap trash: [
        "~LibraryApplication Supportzen",
        "~LibraryCachesMozillaupdatesApplicationsZen Browser",
        "~LibraryCacheszen",
        "~LibraryPreferencesorg.mozilla.com.zen.browser.plist",
        "~LibrarySaved Application Stateorg.mozilla.com.zen.browser.savedState",
      ],
      rmdir: "~LibraryCachesMozilla"
end