cask "zen-browser" do
  arch arm: "aarch64", intel: "x64"

  version "1.0.1-a.1"
  sha256 arm:   "b7ed2c901ec3294ed126b969f55f41e5a709952b3193db10559ca4b599158940",
         intel: "c24de599a5189e79e6b5a390b973e4d31abecc60353c8e79bf693a0ff44690f8"

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