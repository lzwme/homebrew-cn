cask "museeks" do
  version "0.22.1"
  sha256 "e10340fe14f1c367e81030e53c4c2ed883cf620a8ab05a8bfb6d3c08516edba9"

  url "https:github.commartpiemuseeksreleasesdownload#{version}Museeks_#{version}_universal.dmg",
      verified: "github.commartpiemuseeks"
  name "Museeks"
  desc "Music player"
  homepage "https:museeks.io"

  depends_on macos: ">= :high_sierra"

  app "Museeks.app"

  zap trash: [
    "~LibraryApplication Supportmuseeks",
    "~LibrarySaved Application Statecom.electron.museeks.savedState",
  ]
end