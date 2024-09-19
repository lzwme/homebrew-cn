cask "font-sn-pro" do
  version "1.2.0"
  sha256 "1bd89ccc333df57ca959207b83282fcd6b9806d71070244394a892ea280ac792"

  url "https:github.comsupernotessn-proreleasesdownload#{version}SN-Pro.zip",
      verified: "github.comsupernotessn-pro"
  name "SN Pro Font Family"
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