cask "oversight" do
  version "2.3.0"
  sha256 "a78a997427ba29a01285cb0bdd84a88c600c6cb3855017f9f31a47ad350dd94c"

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