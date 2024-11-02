cask "zen-browser" do
  arch arm: "aarch64", intel: "x64"

  version "1.0.1-a.17"
  sha256 arm:   "6c3d3563b81ffbe7a071bf6f76af88a1db361d3adaca14558df80b9215d5012d",
         intel: "8ee7457bb98d3d83d2ec3f56426d230061474121e0cb74fe4e5979311a034861"

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