cask "pairpods" do
  version "0.3.0"
  sha256 "a99221a4096fda3653015c87cd509a29740bf08264a05c519a2c7a5d108fb8af"

  url "https://ghfast.top/https://github.com/wozniakpawel/PairPods/releases/download/v#{version}/PairPods-#{version}.app.zip",
      verified: "github.com/wozniakpawel/PairPods/"
  name "PairPods"
  desc "Share audio between two Bluetooth devices"
  homepage "https://pairpods.app/"

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :ventura"

  app "PairPods.app"

  zap trash: [
    "~/Library/Application Scripts/com.wozniakpawel.PairPods",
    "~/Library/Containers/com.wozniakpawel.PairPods",
  ]
end