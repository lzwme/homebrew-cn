cask "zen-browser@twilight" do
  version "1.11.5t"
  sha256 :no_check

  url "https:github.comzen-browserdesktopreleasesdownloadtwilightzen.macos-universal.dmg",
      verified: "github.comzen-browserdesktop"
  name "Zen Twilight"
  desc "Gecko based web browser"
  homepage "https:zen-browser.app"

  livecheck do
    url "https:updates.zen-browser.appupdatesbrowserDarwin_aarch64-gcc3twilightupdate.xml"
    strategy :xml do |xml|
      xml.get_elements("update").map { |item| item.attributes["appVersion"] }
    end
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Twilight.app"

  zap trash: [
        "~LibraryApplication SupportZen",
        "~LibraryCachesMozillaupdatesApplicationsTwilight",
        "~LibraryCachesMozillaupdatesApplicationsZen Twilight",
        "~LibraryCachesZen",
        "~LibraryPreferencesapp.zen-browser.zen.plist",
        "~LibraryPreferencesorg.mozilla.com.zen.browser.plist",
        "~LibrarySaved Application Stateapp.zen-browser.zen.savedState",
        "~LibrarySaved Application Stateorg.mozilla.com.zen.browser.savedState",
      ],
      rmdir: "~LibraryCachesMozilla"
end