cask "spatterlight" do
  version "1.2.7"
  sha256 "b3b9893fab018c8bb8858ea2eeee596440d966b6e00dfa20cb8303007ddae22e"

  url "https:github.comangstsmurfspatterlightreleasesdownloadv#{version}Spatterlight.zip",
      verified: "github.comangstsmurfspatterlight"
  name "Spatterlight"
  desc "Play most kinds of interactive fiction game files"
  homepage "https:ccxvii.netspatterlight"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "Spatterlight.app"

  zap trash: [
    "~LibraryApplication Scriptsnet.ccxvii.spatterlight.*",
    "~LibraryContainersnet.ccxvii.spatterlight.*",
    "~LibraryPreferencesnet.ccxvii.spatterlight.plist",
  ]
end