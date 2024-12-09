cask "neohtop" do
  arch arm: "silicon", intel: "intel"
  platform = on_arch_conditional arm: "aarch64", intel: "x64"

  version "1.1.2"
  sha256 arm:   "41b8e8eb8a9d897d8485760a6da34f2e135902756c4d5edcedf54d09410a5d77",
         intel: "1526320351b9199ba58d69d34450661262bbe42264fbc3facc7dcddd20ce7bb8"

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