cask "pdfsam-basic" do
  version "5.2.4"
  sha256 "b28956f39d8828ded5b087c76ce9cb30a252d73f3b2a5501ba331b45675fe668"

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