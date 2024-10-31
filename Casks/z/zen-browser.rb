cask "zen-browser" do
  arch arm: "aarch64", intel: "x64"

  version "1.0.1-a.15"
  sha256 arm:   "fb26346a7e265ee6a40ae7945478076b721a00eeb49c78658324d0d555d3cd67",
         intel: "705d0dfbaebc334f14b451e591b7a6c39783e610796c800e01f56797644b5f48"

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