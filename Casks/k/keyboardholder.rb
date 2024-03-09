cask "keyboardholder" do
  version "1.12.12"
  sha256 "466e74709dabe6c1a06ba3096f62d61e768e36fcd15f28ba6341d521b029dd09"

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