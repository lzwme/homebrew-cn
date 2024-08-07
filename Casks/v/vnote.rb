cask "vnote" do
  version "3.18.2"
  sha256 "47c64e64933d9de081805e5474038cbd9cae171e1bcfc131fbf522fb2eeb9b1c"

  url "https:github.comvnotexvnotereleasesdownloadv#{version}VNote-#{version}-mac-universal.dmg",
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