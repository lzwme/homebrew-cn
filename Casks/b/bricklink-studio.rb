cask "bricklink-studio" do
  version "2.23.10_1"
  sha256 "30a509c1c60b85fc8c85c31779affbe00ab54334ed6716aeea107a067cdd2846"

  url "https://blstudio.s3.amazonaws.com/Studio#{version.major}.0/Archive/#{version}/Studio+#{version.major}.0.pkg",
      verified: "blstudio.s3.amazonaws.com/"
  name "Studio"
  desc "Build, render, and create LEGO instructions"
  homepage "https://www.bricklink.com/v3/studio/download.page"

  livecheck do
    url "https://store.bricklink.com/v2/studio/download.page"
    regex(/"version"\s*:\s*"(\d+(?:[._-]\d+)*)"/i)
  end

  auto_updates true

  pkg "Studio+#{version.major}.0.pkg"

  uninstall pkgutil: "com.bricklink.pkg.Studio#{version.major}.0"

  zap trash: [
    "~/Library/Application Support/unity.BrickLink.Studio",
    "~/Library/Caches/com.plausiblelabs.crashreporter.data/unity.BrickLink.Studio",
    "~/Library/Preferences/unity.BrickLink.Patcher.plist",
    "~/Library/Preferences/unity.BrickLink.Studio.plist",
    "~/Library/Saved Application State/unity.BrickLink.Patcher.savedState",
    "~/Library/Saved Application State/unity.BrickLink.Studio.savedState",
  ]
end