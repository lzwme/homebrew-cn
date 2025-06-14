cask "droidcam-obs" do
  version "2.3.4"
  sha256 "ad3254ab2901cf1d9deebc7f42053f64a728bf2c1b706be588028604ae037e33"

  url "https:github.comdev47appsdroidcam-obs-pluginreleasesdownload#{version}DroidCamOBS_#{version}_macos.pkg",
      verified: "github.comdev47appsdroidcam-obs-plugin"
  name "DroidCam OBS"
  desc "Use your phone as a camera directly in OBS Studio"
  homepage "https:www.dev47apps.comobs"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on cask: "obs"

  pkg "DroidCamOBS_#{version}_macos.pkg"

  uninstall pkgutil: "com.dev47apps.droidcamobs",
            delete:  "LibraryApplication Supportobs-studiopluginsdroidcam-obs",
            rmdir:   "LibraryApplication Supportobs-studioplugins"

  # No zap stanza required
end