cask "flacon" do
  version "11.4.0"
  sha256 "a9cf25ae5c1ae7ed6c1c11d97d23a6f538cca8e79a18deac5aaafd93174b6403"

  url "https:github.comflaconflaconreleasesdownloadv#{version}Flacon_#{version}.dmg",
      verified: "github.comflaconflacon"
  name "Flacon"
  desc "Open source audio file encoder"
  homepage "https:flacon.github.io"

  livecheck do
    url "https:flacon.github.iodownloadfeed.xml"
    strategy :sparkle
  end

  auto_updates true

  app "Flacon.app"

  zap trash: [
    "~LibraryPreferencescom.flacon.flacon.plist",
    "~LibraryPreferencesio.github.flacon.plist",
    "~LibrarySaved Application Stateio.github.flacon.savedState",
  ]
end