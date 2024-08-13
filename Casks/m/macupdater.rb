cask "macupdater" do
  on_monterey :or_older do
    version "2.3.15"
    sha256 "9d6775c99b2a76d3f3be0e3d23c27305666341be16d38a0661c8d9cfa50e5256"
  end
  on_ventura :or_newer do
    version "3.3.2"
    # required as upstream package is regularly updated in-place https:github.comHomebrewhomebrew-caskpull182188#issuecomment-2284199515
    sha256 :no_check

    binary "#{appdir}MacUpdater.appContentsResourcesmacupdater_install"
  end

  url "https:www.corecode.iodownloadsmacupdater_#{version}.dmg"
  name "MacUpdater"
  desc "Track and update to the latest versions of installed software"
  homepage "https:www.corecode.iomacupdaterindex.html"

  livecheck do
    url "https:www.corecode.iomacupdatermacupdater#{version.major}.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :mojave"

  app "MacUpdater.app"
  binary "#{appdir}MacUpdater.appContentsResourcesmacupdater_client"

  uninstall launchctl: "com.corecode.MacUpdaterLaunchHelper",
            quit:      "com.corecode.MacUpdater"

  zap trash: [
    "~LibraryApplication Scriptscom.corecode.MacUpdaterLaunchHelper",
    "~LibraryApplication SupportMacUpdater*",
    "~LibraryCachescom.corecode.MacUpdater",
    "~LibraryContainerscom.corecode.MacUpdaterLaunchHelper",
    "~LibraryCookiescom.corecode.MacUpdater.binarycookies",
    "~LibraryPreferencescom.corecode.MacUpdater.plist",
  ]
end