cask "neohtop" do
  arch arm: "silicon", intel: "intel"
  platform = on_arch_conditional arm: "aarch64", intel: "x64"

  version "1.2.0"
  sha256 arm:   "c099c72765aa6e95b17ebecc3fb49b784934b94f179e4c71c718dd44dd293af2",
         intel: "771144c097c3991d89685b68d637a89f556b6b6ddbdb60e6fe7bdcddb879c61f"

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