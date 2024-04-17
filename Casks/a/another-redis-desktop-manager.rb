cask "another-redis-desktop-manager" do
  arch arm: "-M1-arm64-", intel: "."

  version "1.6.4"
  sha256 arm:   "8bbc2a2431dde2d3ce61aa8022abb121c0a62604f443a9af707011b951930030",
         intel: "f1510b1968342be3fc412c577dc4905c52850ab3577d0bf5871ad7e093c2e271"

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