cask "keyboardholder" do
  version "1.12.11"
  sha256 "ee26d90d411ef338ca5b698640db16fdd8147dcdb90610029e42885d4ebd2ba3"

  url "https:github.comleaves615KeyboardHolderreleasesdownloadv#{version}KeyboardHolder-#{version}.zip",
      verified: "github.comleaves615KeyboardHolder"
  name "KeyboardHolder"
  desc "Switch input method per application"
  homepage "https:keyboardholder.leavesc.com"

  app "KeyboardHolder.app"

  zap trash: [
    "~LibraryApplication Scriptscn.leaves.KeyboardHolderLaunchHelper",
    "~LibraryApplication Supportcn.leaves.KeyboardHolder",
    "~LibraryCachescn.leaves.KeyboardHolder",
    "~LibraryCachescom.plausiblelabs.crashreporter.datacn.leaves.KeyboardHolder",
    "~LibraryContainerscn.leaves.KeyboardHolderLaunchHelper",
    "~LibraryLogscn.leaves.KeyboardHolder",
    "~LibraryPreferencescn.leaves.KeyboardHolder.plist",
  ]
end