cask "restfox" do
  version "0.6.0"
  sha256 "7b75299368b16db2b0b6e354b0c8342d8cb9e8bbe8c64d0b4be6ae0b1a1a5aae"

  url "https:github.comflawiddsouzaRestfoxreleasesdownloadv#{version}Restfox-darwin-x64-#{version}.zip",
      verified: "github.comflawiddsouzaRestfoxreleasesdownload"
  name "Restfox"
  desc "Offline-first web HTTP client"
  homepage "https:restfox.dev"

  auto_updates true

  app "Restfox.app"

  zap trash: "~LibraryApplication SupportRestfox"
end