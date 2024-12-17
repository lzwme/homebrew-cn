cask "blockstack" do
  version "0.37.0"
  sha256 "c51a900432b7b7c2885ccd285027ff7c9656f87e934d54bb48dbfbae43ccdf32"

  url "https:github.comblockstackblockstack-browserreleasesdownloadv#{version}Blockstack-for-macOS-v#{version}.dmg",
      verified: "github.comblockstackblockstack-browser"
  name "Blockstack"
  desc "Explore the Blockstack internet"
  homepage "https:blockstack.org"

  disable! date: "2024-12-16", because: :discontinued

  depends_on macos: ">= :sierra"

  app "Blockstack.app"
end