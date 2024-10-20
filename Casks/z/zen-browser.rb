cask "zen-browser" do
  arch arm: "aarch64", intel: "x64"

  version "1.0.1-a.12"
  sha256 arm:   "e425784dd8747daf3a8f1e645e0b1ec7f348ded4ebd09eb9fde74f692b0d30ba",
         intel: "17c1b4422bb7ded4b40d227d6d2d4d0adfc18be07e8680feb3b07242081a15b0"

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