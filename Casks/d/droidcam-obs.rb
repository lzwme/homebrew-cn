cask "droidcam-obs" do
  version "2.3.2"
  sha256 "1f0ab3d89545caf823f58b3d9e223c0aeb26176c1403983c475261b2f212d4ca"

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