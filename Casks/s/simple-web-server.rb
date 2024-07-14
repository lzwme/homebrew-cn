cask "simple-web-server" do
  arch arm: "arm64", intel: "x64"

  version "1.2.12"
  sha256 arm:   "3d685dd533e986e8b705b4e74832d984c327f041b3dd4fab6a5f061b9e8890c8",
         intel: "5c4489781578e65da66ee88ac3c9ffcd81b3da9199226bf1a0060ee727982439"

  url "https:github.comterrengsimple-web-serverreleasesdownloadv#{version}Simple-Web-Server-macOS-#{version}-#{arch}.dmg",
      verified: "github.comterrengsimple-web-server"
  name "Simple Web Server"
  desc "Create local web servers"
  homepage "https:simplewebserver.org"

  app "Simple Web Server.app"

  zap trash: [
    "~LibraryApplication SupportSimple Web Server",
    "~LibraryPreferencesorg.simplewebserver.simplewebserver.plist",
    "~LibrarySaved Application Stateorg.simplewebserver.simplewebserver.savedState",
  ]
end