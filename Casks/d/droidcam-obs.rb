cask "droidcam-obs" do
  version "2.2.1"
  sha256 "6fc10d20264452f42d99cd74b23c2a5056ff61f75f1dcbaaf0b7fabb2af866fc"

  url "https:github.comdev47appsdroidcam-obs-pluginreleasesdownload#{version}DroidCamOBS_#{version}_macos.pkg",
      verified: "github.comdev47appsdroidcam-obs-plugin"
  name "DroidCam OBS"
  desc "Use your phone as a camera directly in OBS Studio"
  homepage "https:www.dev47apps.comobs"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on cask: "obs"

  pkg "DroidCamOBS_#{version}_macos.pkg"

  uninstall pkgutil: "com.dev47apps.droidcamobs",
            delete:  "LibraryApplication Supportobs-studiopluginsdroidcam-obs",
            rmdir:   "LibraryApplication Supportobs-studioplugins"

  # No zap stanza required
end