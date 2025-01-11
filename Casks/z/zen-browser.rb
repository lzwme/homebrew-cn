cask "zen-browser" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.6b"
  sha256 arm:   "92d26a445c06ce667347b843cd863cded2d95fdde4e772109fcbebbab29c86b7",
         intel: "c4e0a3ee2ebb64c729ae652858b26a3fd26ed0580f60916034fa2691b73d25b0"

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