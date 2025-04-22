cask "pairpods" do
  version "0.2.1"
  sha256 "a15c8f25c9be832d51de5df85d379d0e313ddf712d999055f7d3ebd499b9ae2f"

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