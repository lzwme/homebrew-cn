cask "zen-browser@twilight" do
  version "1.8"
  sha256 :no_check

  url "https:github.comzen-browserdesktopreleasesdownloadtwilightzen.macos-universal.dmg",
      verified: "github.comzen-browserdesktop"
  name "Zen Twilight"
  desc "Gecko based web browser"
  homepage "https:zen-browser.app"

  livecheck do
    url "https:github.comzen-browserdesktopreleases?q=twilight"
    regex(%r{tagtwilight[^>]+?>.+?v?(\d+(?:\.\d+)+(?:[._-][a-z]\.\d+)?)}i)
    strategy :page_match
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Zen Twilight.app"

  zap trash: [
        "~LibraryApplication SupportZen",
        "~LibraryCachesMozillaupdatesApplicationsZen Twilight",
        "~LibraryCacheszen",
        "~LibraryPreferencesorg.mozilla.com.zen.browser.plist",
        "~LibrarySaved Application Stateorg.mozilla.com.zen.browser.savedState",
      ],
      rmdir: "~LibraryCachesMozilla"
end