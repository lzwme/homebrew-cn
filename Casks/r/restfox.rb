cask "restfox" do
  version "0.3.2"
  sha256 "b8d443aa61c527f80a30a11093ef98c4254489dab14a5c42b7aed562f2bc8219"

  url "https:github.comflawiddsouzaRestfoxreleasesdownloadv#{version}Restfox-darwin-x64-#{version}.zip",
      verified: "github.comflawiddsouzaRestfoxreleasesdownload"
  name "Restfox"
  desc "Offline-first web HTTP client"
  homepage "https:restfox.dev"

  auto_updates true

  app "Restfox.app"

  zap trash: "~LibraryApplication SupportRestfox"
end