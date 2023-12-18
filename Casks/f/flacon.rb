cask "flacon" do
  version "11.3.0"
  sha256 "f566c4173243da4783124e02240a71b249091b47054a78e217a03c65ee723b31"

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