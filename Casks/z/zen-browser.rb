cask "zen-browser" do
  version "1.11b"
  sha256 "66775c24e2c9602f13d2dee94d96c354d1e147eb33dedeec2008f00056bafb58"

  url "https:github.comzen-browserdesktopreleasesdownload#{version}zen.macos-universal.dmg",
      verified: "github.comzen-browserdesktop"
  name "Zen Browser"
  desc "Gecko based web browser"
  homepage "https:zen-browser.app"

  livecheck do
    url "https:updates.zen-browser.appupdatesbrowserDarwin_aarch64-gcc3releaseupdate.xml"
    strategy :xml do |xml|
      xml.get_elements("update").map { |item| item.attributes["appVersion"] }
    end
  end

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