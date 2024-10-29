cask "pdfsam-basic" do
  version "5.2.9"
  sha256 "aeed981e1f2b80810ef3e0ef5fdec091e6c550779f9ea04aaac94139fc1c695d"

  url "https:github.comtorakikipdfsamreleasesdownloadv#{version}PDFsam-#{version}.dmg",
      verified: "github.comtorakikipdfsam"
  name "PDFsam Basic"
  desc "Extracts pages, splits, merges, mixes and rotates PDF files"
  homepage "https:pdfsam.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "PDFsam Basic.app"

  zap trash: [
    "~LibraryPreferencesorg.pdfsam.modules.plist",
    "~LibraryPreferencesorg.pdfsam.stage.plist",
    "~LibraryPreferencesorg.pdfsam.user.plist",
    "~LibrarySaved Application Stateorg.pdfsam.basic.savedState",
  ]

  caveats do
    requires_rosetta
  end
end