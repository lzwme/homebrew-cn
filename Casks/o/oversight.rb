cask "oversight" do
  version "2.2.2"
  sha256 "2e0eba973c0f76e4468a7d7f949d34628b06d735bcf64c170d20e79f29d70915"

  url "https:github.comobjective-seeOverSightreleasesdownloadv#{version}OverSight_#{version}.zip",
      verified: "github.comobjective-seeOverSight"
  name "OverSight"
  desc "Monitors computer mic and webcam"
  homepage "https:objective-see.comproductsoversight.html"

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