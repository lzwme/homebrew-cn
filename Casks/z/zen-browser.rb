cask "zen-browser" do
  version "1.8b"
  sha256 "bc02208199d54cefa7c3d6503185e5d5e512181f1f387df0538f312b0e0ef73f"

  url "https:github.comzen-browserdesktopreleasesdownload#{version}zen.macos-universal.dmg",
      verified: "github.comzen-browserdesktop"
  name "Zen Browser"
  desc "Gecko based web browser"
  homepage "https:zen-browser.app"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Zen.app"

  zap trash: [
        "~LibraryApplication SupportZen",
        "~LibraryCachesMozillaupdatesApplicationsZen Browser",
        "~LibraryCachesMozillaupdatesApplicationsZen",
        "~LibraryCachesZen",
        "~LibraryPreferencesapp.zen-browser.zen.plist",
        "~LibraryPreferencesorg.mozilla.com.zen.browser.plist",
        "~LibrarySaved Application Stateapp.zen-browser.zen.savedState",
        "~LibrarySaved Application Stateorg.mozilla.com.zen.browser.savedState",
      ],
      rmdir: "~LibraryCachesMozilla"
end