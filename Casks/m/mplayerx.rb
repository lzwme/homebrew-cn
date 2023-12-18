cask "mplayerx" do
  version "1.1.4,1920"
  sha256 "9306b11acd9df45464fc3ddca1a3a757f50ef019ea6a09ce13ad3f51f1ef1592"

  url "https:github.comniltshMPlayerX-Deployreleasesdownload#{version.csv.first}MPlayerX-#{version.csv.first}-#{version.csv.second}.zip",
      verified: "github.comniltshMPlayerX-Deploy"
  name "MPlayerX"
  desc "Media player"
  homepage "http:mplayerx.org"

  livecheck do
    url "https:raw.githubusercontent.comniltshMPlayerX-Deploymasterappcast.xml"
    strategy :sparkle
  end

  auto_updates true

  app "MPlayerX.app"

  zap trash: [
    "~.mplayer",
    "~LibraryApplication SupportMPlayerX",
    "~LibraryPreferencesorg.niltsh.MPlayerX.LSSharedFileList.plist",
    "~LibraryPreferencesorg.niltsh.MPlayerX.plist",
    "~LibraryCachesorg.niltsh.MPlayerX",
  ]
end