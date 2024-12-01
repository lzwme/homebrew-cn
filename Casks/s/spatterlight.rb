cask "spatterlight" do
  version "1.3"
  sha256 "ca285b166f7b8f9f6b13dba38dd518a89a5184c655926f80c882d5227ff6af3c"

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