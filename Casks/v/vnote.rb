cask "vnote" do
  version "3.19.1"
  sha256 "8b2f32f57a94dcf20e4de7ea98fa073d735a6ed70dd697e67af909b6537a6f66"

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