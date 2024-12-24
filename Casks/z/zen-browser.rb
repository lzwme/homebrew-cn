cask "zen-browser" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.0.2-b.4"
  sha256 arm:   "17b086be8e3dbc09d75e183cf0ac2201cf3c95288f343aa11c5f8d5d23fabd91",
         intel: "124c00b0cc207fe0702dc09107197d1d33a63105e7fd98e1752ab226e3e9c0eb"

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