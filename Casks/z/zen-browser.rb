cask "zen-browser" do
  arch arm: "aarch64", intel: "x64"

  version "1.0.1-a"
  sha256 arm:   "4f2d047f2bf40ec519d0c1f3a72f6a239a99c4eabca4274bc01428c7cedc7ff9",
         intel: "700f7cd0a2ca33a5288faa3213737b3110c87a60c09b8806206605d8ced9b426"

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