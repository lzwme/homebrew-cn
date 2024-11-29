cask "zen-browser" do
  arch arm: "aarch64", intel: "x64"

  version "1.0.1-a.22"
  sha256 arm:   "32e9fbcc1fa85a3f4ec18dad4877f22aaef06f96468639aa67107c38f715f838",
         intel: "b24b3f16b5c57a57cf37107dec5308f9b05d876bdf74b8e185e39ace8122a423"

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