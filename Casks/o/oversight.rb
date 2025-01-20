cask "oversight" do
  version "2.4.0"
  sha256 "2352214830d0c6c827b8e010d8dea59351dcba15019683a6e4686119174b99b9"

  url "https:github.comobjective-seeOverSightreleasesdownloadv#{version}OverSight_#{version}.zip",
      verified: "github.comobjective-seeOverSight"
  name "OverSight"
  desc "Monitors computer mic and webcam"
  homepage "https:objective-see.orgproductsoversight.html"

  depends_on macos: ">= :monterey"

  installer script: {
    executable: "#{staged_path}OverSight Installer.appContentsMacOSOverSight Installer",
    args:       ["-install"],
    sudo:       true,
  }

  uninstall script: {
    executable: "#{staged_path}OverSight Installer.appContentsMacOSOverSight Installer",
    args:       ["-uninstall"],
    sudo:       true,
  }

  zap trash: [
    "~LibraryCachescom.objective-see.oversight",
    "~LibraryCachescom.objective-see.OverSightHelper",
    "~LibraryPreferencescom.objective-see.oversight.plist",
    "~LibraryPreferencescom.objective-see.OverSightHelper.plist",
  ]
end