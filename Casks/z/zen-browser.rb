cask "zen-browser" do
  arch arm: "aarch64", intel: "x64"

  version "1.0.1-a.10"
  sha256 arm:   "797bc25b504d209790fd817d54b92170bb0c987006cad26641c8262870a431a8",
         intel: "3f60e9d164648ecbba119b675dad39d34801227800753b5346f15f6aa1ca1ab3"

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