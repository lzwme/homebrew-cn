cask "vnote" do
  version "3.18.0"
  sha256 "3720cea666f2c7e44bba1729f6bde39f4acd2b3d3c2cd014e228388c67f1e613"

  url "https:github.comvnotexvnotereleasesdownloadv#{version}vnote-#{version}-mac-universal.zip",
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