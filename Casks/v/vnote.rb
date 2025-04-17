cask "vnote" do
  version "3.19.0"
  sha256 "da9b5972f4905f6bd0845fb5399a903d7add269bea0e9f3f68692c1741fc1f2d"

  url "https:github.comvnotexvnotereleasesdownloadv#{version}VNote-#{version}-mac-universal.zip",
      verified: "github.comvnotexvnote"
  name "VNote"
  desc "Note-taking platform"
  homepage "https:vnotex.github.iovnote"

  depends_on macos: ">= :monterey"

  app "VNote.app"

  zap trash: [
    "~LibraryApplication SupportVNote",
    "~LibraryPreferencescom.vnotex.vnote.plist",
    "~LibraryPreferencesVNote",
  ]
end