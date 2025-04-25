cask "pairpods" do
  version "0.3.0"
  sha256 "a99221a4096fda3653015c87cd509a29740bf08264a05c519a2c7a5d108fb8af"

  url "https:github.comwozniakpawelPairPodsreleasesdownloadv#{version}PairPods-#{version}.app.zip",
      verified: "github.comwozniakpawelPairPods"
  name "PairPods"
  desc "Share audio between two Bluetooth devices"
  homepage "https:pairpods.app"

  auto_updates true
  depends_on macos: ">= :ventura"

  app "PairPods.app"

  zap trash: [
    "~LibraryApplication Scriptscom.wozniakpawel.PairPods",
    "~LibraryContainerscom.wozniakpawel.PairPods",
  ]
end