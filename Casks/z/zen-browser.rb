cask "zen-browser" do
  arch arm: "aarch64", intel: "x64"

  version "1.0.1-a.14"
  sha256 arm:   "054a4183ba6cb3822ba6a7b8ad501a68d59a47fd1b518f8c7aa2b884ab655dad",
         intel: "04cd708b9aea698c326363249ebb388b801e5a158f3185e8cf14dbc489758105"

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