cask "font-sn-pro" do
  version "1.1.0"
  sha256 "b8953185881a741e62912033d0fdc0ad99f31e470c6a51c07859f883ec26ee19"

  url "https:github.comsupernotessn-proreleasesdownload#{version}SN-Pro.zip",
      verified: "github.comsupernotessn-pro"
  name "SN Pro Font Family"
  desc "SN Pro is a friendly sans serif typeface optimized for use with Markdown"
  homepage "https:supernotes.appopen-sourcesn-pro"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "SNProSNPro-Black.otf"
  font "SNProSNPro-BlackItalic.otf"
  font "SNProSNPro-Bold.otf"
  font "SNProSNPro-BoldItalic.otf"
  font "SNProSNPro-Heavy.otf"
  font "SNProSNPro-HeavyItalic.otf"
  font "SNProSNPro-Light.otf"
  font "SNProSNPro-LightItalic.otf"
  font "SNProSNPro-Medium.otf"
  font "SNProSNPro-MediumItalic.otf"
  font "SNProSNPro-Regular.otf"
  font "SNProSNPro-RegularItalic.otf"
  font "SNProSNPro-Semibold.otf"
  font "SNProSNPro-SemiboldItalic.otf"
  font "SNProSNPro-Thin.otf"
  font "SNProSNPro-ThinItalic.otf"

  # No zap stanza required
end