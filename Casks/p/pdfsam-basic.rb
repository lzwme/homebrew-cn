cask "pdfsam-basic" do
  version "5.2.6"
  sha256 "8fc5d1ec50db9f1776d1c1b91cd2c5c4d644979e43b0ced462440bfa9a5143e1"

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