cask "quicklook-pfm" do
  version "1.1"
  sha256 "53308ac3d7f0f8ed02adb2feff282764fdeadb32352b0776caeaec3d6a514333"

  url "https://ghfast.top/https://github.com/lnxbil/quicklook-pfm/releases/download/#{version}/quicklook-pfm-#{version}.zip"
  name "quicklook-pfm"
  desc "Quick Look plugin for PPM, PGM, PFM and PBM files"
  homepage "https://github.com/lnxbil/quicklook-pfm"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  qlplugin "Quicklook-PFM.qlgenerator"

  # No zap stanza required
end