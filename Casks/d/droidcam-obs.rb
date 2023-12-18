cask "droidcam-obs" do
  version "2.1.0"
  sha256 "656962d23b18cabb4e54cd53794ac801aaa7fa5d104c32f0dc6b067a4c5d3ea0"

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