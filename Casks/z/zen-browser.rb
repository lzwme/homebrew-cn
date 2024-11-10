cask "zen-browser" do
  arch arm: "aarch64", intel: "x64"

  version "1.0.1-a.18"
  sha256 arm:   "d6e98f861dfcfc5d520d2bf5880c9ab66c4c1af90ecf3476ca21b115a7764322",
         intel: "60f28eef843b2f99eb611dc57ddffc48f19304edc65b7f95a2be1cd20230194b"

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