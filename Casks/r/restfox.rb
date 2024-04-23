cask "restfox" do
  version "0.11.0"
  sha256 "1bb98277511a4f7aae6df3d4834c87342cffa04614577e50b09f1a6a04af95ff"

  url "https:github.comflawiddsouzaRestfoxreleasesdownloadv#{version}Restfox-darwin-x64-#{version}.zip",
      verified: "github.comflawiddsouzaRestfoxreleasesdownload"
  name "Restfox"
  desc "Offline-first web HTTP client"
  homepage "https:restfox.dev"

  auto_updates true

  app "Restfox.app"

  zap trash: "~LibraryApplication SupportRestfox"
end