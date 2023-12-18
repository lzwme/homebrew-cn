cask "another-redis-desktop-manager" do
  arch arm: "-M1-arm64-", intel: "."

  version "1.6.1"
  sha256 arm:   "cd532b82c3292aab4f4c29b3f38b6159c24ec1cb97ecc61605e0d2d05fea099c",
         intel: "05b4f88dfd95ab7b9c08938c1e1338a6df09c4f8a7d0b2a1bd40fb4c93b536ff"

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