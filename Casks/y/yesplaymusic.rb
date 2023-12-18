cask "yesplaymusic" do
  version "0.4.7"
  sha256 "d41dee5dd151673b62115dd391e89d50567072f044b3a7bfc07bd584d835263a"

  url "https:github.comqier222YesPlayMusicreleasesdownloadv#{version}YesPlayMusic-mac-#{version}-universal.dmg"
  name "YesPlayMusic"
  desc "Third-party NetEase cloud player"
  homepage "https:github.comqier222YesPlayMusic"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "YesPlayMusic.app"

  zap trash: [
    "~LibraryApplication SupportYesPlayMusic",
    "~LibraryPreferencescom.electron.yesplaymusic.plist",
    "~LibrarySaved Application Statecom.electron.yesplaymusic.savedState",
  ]
end