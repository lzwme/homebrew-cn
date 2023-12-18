cask "opensesame" do
  version "4.0.13"
  sha256 "60836525f04ffd6db16772e0697769f147ebcfd0797c895d21864b8e95db7f44"

  url "https:github.comopen-cogsciOpenSesamereleasesdownloadrelease%2F#{version}opensesame_#{version}-py311-macos-x64-1.dmg",
      verified: "github.comopen-cogsciOpenSesame"
  name "OpenSesame"
  desc "Graphical experiment builder for the social sciences"
  homepage "https:osdoc.cogsci.nl"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "OpenSesame.app"

  zap trash: [
    "~.opensesame",
    "~LibraryPreferencescom.cogscinl.default.plist",
  ]
end