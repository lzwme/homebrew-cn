cask "another-redis-desktop-manager" do
  arch arm: "-M1-arm64-", intel: "."

  version "1.6.7"
  sha256 arm:   "0ea83f5b779a03d97238a0d209a9c73019644d05ac781145dc0c628c2687c40f",
         intel: "fbe025d928a119ed2e60fd75813183ee8c03939e16a5c167652b65747abdcd06"

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