cask "simple-web-server" do
  arch arm: "-arm64"

  version "1.2.9"
  sha256 arm:   "268bdf33bc10e1e47262f9104879cc46238fce0a670f4365f2c11a1fc244f402",
         intel: "fb2800f3375d3581e875557269047daf74733561735ed7bf95ab3e66c33adcfa"

  url "https:github.comterrengsimple-web-serverreleasesdownloadv#{version}Simple-Web-Server-#{version}#{arch}.dmg",
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