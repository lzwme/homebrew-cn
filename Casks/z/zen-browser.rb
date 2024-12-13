cask "zen-browser" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.0.2-b.1"
  sha256 arm:   "22230e3bfe9fabec3682302d22d5cd9e671c8e168a921c9a1306883ed56e38e3",
         intel: "73850bbcb73df59e64e53f550904a51f284bf8ca53280f5c1a3a0956da62b84a"

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