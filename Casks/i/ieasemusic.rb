cask "ieasemusic" do
  version "1.3.4"
  sha256 "6b7f6d7be86b5a37f3c203012261ec19bd3492bc489a94c1e1dbcc9299b0cc26"

  url "https:github.comtrazynieaseMusicreleasesdownloadv#{version}ieaseMusic-#{version}-mac.dmg"
  name "ieaseMusic"
  desc "Third-party NetEase cloud music player"
  homepage "https:github.comtrazynieaseMusic"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-15", because: :discontinued

  auto_updates true

  app "ieaseMusic.app"

  zap trash: [
    "~LibraryApplication Supportieasemusic",
    "~LibraryPreferencesgh.trazyn.ieasemusic.helper.plist",
    "~LibraryPreferencesgh.trazyn.ieasemusic.plist",
    "~LibrarySaved Application Stategh.trazyn.ieasemusic.savedState",
  ]

  caveats do
    requires_rosetta
  end
end