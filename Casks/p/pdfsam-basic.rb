cask "pdfsam-basic" do
  version "5.2.5"
  sha256 "12c070fcd3074be68c7e8e91c5b18495165a183cf2c6d59067dc1cd779d3c276"

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