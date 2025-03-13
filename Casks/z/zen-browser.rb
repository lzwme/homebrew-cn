cask "zen-browser" do
  version "1.9.1b"
  sha256 "8777674738c9d2b7eb83c6f92bc52c751f1b49c3c867f5778ef8a2ae459bfa05"

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