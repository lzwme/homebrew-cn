cask "museeks" do
  version "0.20.8"
  sha256 "b0156985d16f754b2b25b4685bd7c3c294f82a74bacedf8dca7e1b33552e10d2"

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