cask "zen-browser" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.0.2-b.2"
  sha256 arm:   "af71fe16a735788d1084d4c4a2562b47c6ea921b0f4dcef5290367d9bfb3ea36",
         intel: "9989d2834d6331a838a9a457fd06b7dde6f0d1bd0ac744e6e2c7deda3c674da9"

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