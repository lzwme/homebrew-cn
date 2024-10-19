cask "another-redis-desktop-manager" do
  arch arm: "-M1-arm64-", intel: "."

  version "1.6.8"
  sha256 arm:   "be690389f6623e0bbeb931976de9b0a9bf555541e78a661e3491b88bad09ac21",
         intel: "b8a8c9f35ba43958e43712899940df1601cbac35af4efdf7dacc19e760a4094b"

  url "https:github.comqishiboAnotherRedisDesktopManagerreleasesdownloadv#{version}Another-Redis-Desktop-Manager#{arch}#{version}.dmg"
  name "Another Redis Desktop Manager"
  desc "Redis desktop manager"
  homepage "https:github.comqishiboAnotherRedisDesktopManager"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "Another Redis Desktop Manager.app"

  zap trash: [
    "~LibraryApplication Supportanother-redis-desktop-manager",
    "~LibraryPreferencesme.qii404.another-redis-desktop-manager.plist",
  ]
end