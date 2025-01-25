cask "pdfsam-basic" do
  arch arm: "arm64", intel: "x64"

  version "5.3.0"
  sha256 arm:   "a4c1cc99b46c6f476ab33f6e33110eb0c26186d074be338c841e70dc70ae59fd",
         intel: "5c8a40b6d310a737b3b9fc877c076db0e08147b72fe7e3c6ff784945741de077"

  url "https:github.comtorakikipdfsamreleasesdownloadv#{version}pdfsam-basic-#{version}-macos-#{arch}.dmg",
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
end