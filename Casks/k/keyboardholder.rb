cask "keyboardholder" do
  version "1.13.1"
  sha256 "223006c66d22e60ac6a9ea6abbb06119e5bdf962ee6a39df1fc8124f808ebc66"

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