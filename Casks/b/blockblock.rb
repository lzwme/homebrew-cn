cask "blockblock" do
  on_mojave :or_older do
    version "0.9.9.4"
    sha256 "6ab3a8224e8bc77b9abe8d41492c161454c6b0266e60e61b06931fed4b431282"

    url "https:bitbucket.orgobjective-seedeploydownloadsBlockBlock_#{version}.zip",
        verified: "bitbucket.orgobjective-see"

    installer script: {
      executable: "#{staged_path}BlockBlock Installer.appContentsMacOSBlockBlock",
      args:       ["-install"],
      sudo:       true,
    }

    uninstall script: {
      executable: "#{staged_path}BlockBlock Installer.appContentsMacOSBlockBlock",
      args:       ["-uninstall"],
      sudo:       true,
    }
  end
  on_catalina :or_newer do
    version "2.2.1"
    sha256 "92383188711eb3086f4afcc719e1daed8ed88f5ed057eb198ee7ed3778be3225"

    url "https:github.comobjective-seeBlockBlockreleasesdownloadv#{version}BlockBlock_#{version}.zip",
        verified: "github.comobjective-seeBlockBlock"
  end

  name "BlockBlock"
  desc "Monitors common persistence locations"
  homepage "https:objective-see.comproductsblockblock.html"

  installer script: {
    executable: "#{staged_path}BlockBlock Installer.appContentsMacOSBlockBlock Installer",
    args:       ["-install"],
    sudo:       true,
  }

  uninstall script: {
    executable: "#{staged_path}BlockBlock Installer.appContentsMacOSBlockBlock Installer",
    args:       ["-uninstall"],
    sudo:       true,
  }

  zap trash: [
    "~LibraryCachescom.objective-see.blockblock.helper",
    "~LibraryHTTPStoragescom.objective-see.blockblock.helper",
    "~LibraryPreferencescom.objectiveSee.BlockBlock.plist",
    "~LibraryPreferencescom.objective-see.blockblock.helper.plist",
  ]
end