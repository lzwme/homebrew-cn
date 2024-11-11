cask "neohtop" do
  arch arm: "silicon", intel: "intel"
  platform = on_arch_conditional arm: "aarch64", intel: "x64"

  version "1.1.0"
  sha256 arm:   "895e952ccf7421c41c9d398f700d79a1e7c64d6cdca3f6e865be4556ee05edbc",
         intel: "4ef16ea63940f320880dc8ab966a253813026bf1b6a7c0593a41651dfcbabe43"

  url "https:github.comAbdenasserneohtopreleasesdownloadv#{version}#{arch}-NeoHtop_#{version}_#{platform}.dmg",
      verified: "github.comAbdenasserneohtop"
  name "NeoHtop"
  desc "Htop on steroids"
  homepage "https:abdenasser.github.ioneohtop"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "NeoHtop.app"

  zap trash: [
    "~LibraryCachescom.neohtop.dev",
    "~LibraryWebKitcom.neohtop.dev",
  ]
end