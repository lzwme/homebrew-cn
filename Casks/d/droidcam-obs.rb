cask "droidcam-obs" do
  version "2.3.1"
  sha256 "6ab3836026afadeab2780306b550d7b01e7abe649b3ecac9b34d37bb2e3c16b2"

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