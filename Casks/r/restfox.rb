cask "restfox" do
  version "0.7.1"
  sha256 "725d918db97e31c72a8b0031f56e24dd14e74fe23b8a4d3e170a10cf9eeaf2fd"

  url "https:github.comflawiddsouzaRestfoxreleasesdownloadv#{version}Restfox-darwin-x64-#{version}.zip",
      verified: "github.comflawiddsouzaRestfoxreleasesdownload"
  name "Restfox"
  desc "Offline-first web HTTP client"
  homepage "https:restfox.dev"

  auto_updates true

  app "Restfox.app"

  zap trash: "~LibraryApplication SupportRestfox"
end