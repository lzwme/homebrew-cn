cask "blockblock" do
  version "2.2.5"
  sha256 "836d8c4ccf4bc33be46f019f1f0fcb2ec61e84afa84dbb55098bb0ed7350fc89"

  url "https:github.comobjective-seeBlockBlockreleasesdownloadv#{version}BlockBlock_#{version}.zip",
      verified: "github.comobjective-seeBlockBlock"
  name "BlockBlock"
  desc "Monitors common persistence locations"
  homepage "https:objective-see.orgproductsblockblock.html"

  depends_on macos: ">= :catalina"

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
    "~LibraryPreferencescom.objective-see.blockblock.helper.plist",
    "~LibraryPreferencescom.objectiveSee.BlockBlock.plist",
  ]
end