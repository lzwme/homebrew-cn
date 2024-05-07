cask "keyboardholder" do
  version "1.12.18"
  sha256 "3441c298082b8203624db4062f4c224ca608e83e11726eb61833c59042ce263b"

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