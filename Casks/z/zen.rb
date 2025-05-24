cask "zen" do
  version "1.12.8b"
  sha256 "d4cd47951e436c16366f928e97e7899bc213a4a8f23a83ef6b02e88de0009629"

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
  conflicts_with cask: "zen-privacy"
  depends_on macos: ">= :catalina"

  app "Zen.app"
  binary "#{appdir}Zen.appContentsMacOSzen"

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