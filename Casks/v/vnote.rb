cask "vnote" do
  version "3.19.2"
  sha256 "404ef3a753429cc63a37b114a9c7d7c711b43a6fd7987748acc4760126a12e15"

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