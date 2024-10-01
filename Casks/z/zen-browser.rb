cask "zen-browser" do
  arch arm: "aarch64", intel: "x64"

  version "1.0.1-a.7"
  sha256 arm:   "68b1882b96a25e3fff12d0b117208c6af4098afd44ae2db6137d6694893cc9ea",
         intel: "e594e5fcffb825ef0414b046488ea7dbfdb0bc1b4e668d0b7a440e68180e9b54"

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