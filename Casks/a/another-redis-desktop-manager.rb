cask "another-redis-desktop-manager" do
  arch arm: "arm64", intel: "x64"

  version "1.7.1"
  sha256 arm:   "1833e153cd7d9c66cc6d88ec1448b081dfeb5c122c3c65bcae47be1c4d760235",
         intel: "2e399909abb1c24f963fcd0bf62e493abd76b36d767d7fa9e31bde66008f33bc"

  url "https:github.comqishiboAnotherRedisDesktopManagerreleasesdownloadv#{version}Another-Redis-Desktop-Manager-mac-#{version}-#{arch}.dmg"
  name "Another Redis Desktop Manager"
  desc "Redis desktop manager"
  homepage "https:github.comqishiboAnotherRedisDesktopManager"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Another Redis Desktop Manager.app"

  zap trash: [
    "~LibraryApplication Supportanother-redis-desktop-manager",
    "~LibraryPreferencesme.qii404.another-redis-desktop-manager.plist",
  ]
end