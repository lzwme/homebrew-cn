cask "bit-slicer" do
  version "1.8.0"
  sha256 "4651c4d98541b5caa0747dd35c597252c80b0a635aa2ba821da8f1b1680ef759"

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