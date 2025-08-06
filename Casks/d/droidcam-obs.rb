cask "droidcam-obs" do
  version "2.4.0"
  sha256 "b07347d55efd000c0d7fbe5eea61f053bb2e62b0f0be38242faf170fb0b2e7d0"

  url "https://ghfast.top/https://github.com/dev47apps/droidcam-obs-plugin/releases/download/#{version}/DroidCamOBS_#{version}_macos.pkg",
      verified: "github.com/dev47apps/droidcam-obs-plugin/"
  name "DroidCam OBS"
  desc "Use your phone as a camera directly in OBS Studio"
  homepage "https://www.dev47apps.com/obs/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on cask: "obs"

  pkg "DroidCamOBS_#{version}_macos.pkg"

  uninstall pkgutil: "com.dev47apps.droidcamobs",
            delete:  "/Library/Application Support/obs-studio/plugins/droidcam-obs",
            rmdir:   "/Library/Application Support/obs-studio/plugins"

  # No zap stanza required
end