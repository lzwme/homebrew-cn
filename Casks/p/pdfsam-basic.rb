cask "pdfsam-basic" do
  version "5.2.3"
  sha256 "a492b8c27c26aaeaaed6023df433f56bc82468d6baa2d78c1ef63c915217be32"

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