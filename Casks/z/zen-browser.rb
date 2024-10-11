cask "zen-browser" do
  arch arm: "aarch64", intel: "x64"

  version "1.0.1-a.8"
  sha256 arm:   "ce63a224e81bcc47b1343ac28ad5a5efff36c3effdaaca47ed62f3991cc6ccef",
         intel: "c8157075061f0b5a52ddb878b61fe3278835035bf6f6fee7cc31c07ec0d0d68e"

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