cask "restfox" do
  version "0.8.0"
  sha256 "aa0b1fa659cb1f142ee3488b375a222ed48286904013dc24d07a442454ee6e7a"

  url "https:github.comflawiddsouzaRestfoxreleasesdownloadv#{version}Restfox-darwin-x64-#{version}.zip",
      verified: "github.comflawiddsouzaRestfoxreleasesdownload"
  name "Restfox"
  desc "Offline-first web HTTP client"
  homepage "https:restfox.dev"

  auto_updates true

  app "Restfox.app"

  zap trash: "~LibraryApplication SupportRestfox"
end