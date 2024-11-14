cask "spatterlight" do
  version "1.2.7"
  sha256 "5085d599c87275ff24aecbd00e5d15d992b5172428f1e6242b7aa051096b44be"

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