cask "another-redis-desktop-manager" do
  arch arm: "-M1-arm64-", intel: "."

  version "1.6.3"
  sha256 arm:   "6e51cea0a83790bd339c8b6927a13bccbc9f0008a18961506b85cfc5fadab32f",
         intel: "d2d98dfba3ccaaf4a2262b496afd3369587ce3e85972c33dcde8d4fb2d9966cf"

  url "https:github.comqishiboAnotherRedisDesktopManagerreleasesdownloadv#{version}Another-Redis-Desktop-Manager#{arch}#{version}.dmg"
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