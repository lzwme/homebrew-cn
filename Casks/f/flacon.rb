cask "flacon" do
  version "12.0.0"
  sha256 "3fb524089b3fe3ae26559bba36d462d39d5cef9330f27487d083b95eb94323a5"

  url "https:github.comflaconflaconreleasesdownloadv#{version}Flacon_#{version}.dmg",
      verified: "github.comflaconflacon"
  name "Flacon"
  desc "Open source audio file encoder"
  homepage "https:flacon.github.io"

  livecheck do
    url "https:flacon.github.iodownloadfeed.xml"
    strategy :sparkle
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Flacon.app"

  zap trash: [
    "~LibraryPreferencescom.flacon.flacon.plist",
    "~LibraryPreferencesio.github.flacon.plist",
    "~LibrarySaved Application Stateio.github.flacon.savedState",
  ]
end