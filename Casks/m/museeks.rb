cask "museeks" do
  version "0.20.6"
  sha256 "a598d838c15b34f2bb853cdea9defa8fd3a8e52bf81c9c25689234896ec23095"

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