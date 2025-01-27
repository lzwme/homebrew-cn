cask "bit-slicer" do
  version "1.8.1"
  sha256 "5bd60a027c1b37471aa38f2d2fdefc9d5c1428e7a979215d96ae9523b1c00952"

  url "https:github.comzorgiepooBit-Slicerreleasesdownload#{version}Bit.Slicer.dmg"
  name "Bit Slicer"
  desc "Universal game trainer"
  homepage "https:github.comzorgiepoobit-slicer"

  depends_on macos: ">= :mojave"

  app "Bit Slicer.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.zgcoder.bitslicer.sfl*",
    "~LibraryPreferencescom.zgcoder.BitSlicer.plist",
    "~LibrarySaved Application Statecom.zgcoder.BitSlicer.savedState",
  ]
end