cask "keyboardholder" do
  version "1.12.10"
  sha256 "1b8a9114c708b9aa4919cf310da063ba3ccc372d62c04c07d32372b67efef560"

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