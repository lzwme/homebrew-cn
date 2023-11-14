cask "obs-ndi" do
  version "4.12.0"
  sha256 "89e6d4505481fa4c7d2ce2d239e3fa5aebf6f385c0040b9f0748a667b0a95d09"

  url "https://ghproxy.com/https://github.com/obs-ndi/obs-ndi/releases/download/#{version}/obs-ndi-#{version}-macos-universal.pkg"
  name "obs-ndi"
  desc "NDI integration for OBS Studio"
  homepage "https://github.com/obs-ndi/obs-ndi"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on cask: "libndi"

  pkg "obs-ndi-#{version}-macOS-universal.pkg"

  uninstall pkgutil: [
    "com.newtek.ndi.runtime",
    "fr.palakis.obs-ndi",
    "'fr.palakis.obs-ndi'",
  ]

  # No zap stanza required
end