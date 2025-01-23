cask "zen-browser" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.7.2b"
  sha256 arm:   "1e1c004d22e9eae0806bf4c62e932b1ab8e24dba011b563408eb573ef5439605",
         intel: "a8dc7f04a87f24f51fc80fbb946629c3d66a10740275690747fed97ed7ba5ae0"

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