cask "bit-slicer" do
  version "1.8.2"
  sha256 "376e15d1c193e532ca5666a07dbc918eca1d549146397bc5e5278ec5db0a425f"

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