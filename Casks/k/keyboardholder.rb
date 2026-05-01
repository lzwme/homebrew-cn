cask "keyboardholder" do
  version "1.14.8"
  sha256 "3de2a2f26f7910f4a89ea642a91546799919f227cb03a47eeb3d3a88532d0d42"

  url "https://ghfast.top/https://github.com/leaves615/KeyboardHolder/releases/download/v#{version}/KeyboardHolder-#{version}.zip",
      verified: "github.com/leaves615/KeyboardHolder/"
  name "KeyboardHolder"
  desc "Switch input method per application"
  homepage "https://keyboardholder.leavesc.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  depends_on macos: ">= :big_sur"

  app "KeyboardHolder.app"

  zap trash: [
    "~/Library/Application Scripts/cn.leaves.KeyboardHolderLaunchHelper",
    "~/Library/Application Support/cn.leaves.KeyboardHolder",
    "~/Library/Caches/cn.leaves.KeyboardHolder",
    "~/Library/Caches/com.plausiblelabs.crashreporter.data/cn.leaves.KeyboardHolder",
    "~/Library/Containers/cn.leaves.KeyboardHolderLaunchHelper",
    "~/Library/Logs/cn.leaves.KeyboardHolder",
    "~/Library/Preferences/cn.leaves.KeyboardHolder.plist",
  ]
end