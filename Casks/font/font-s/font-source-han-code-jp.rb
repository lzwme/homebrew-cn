cask "font-source-han-code-jp" do
  version "2.012R"
  sha256 "678a3bf747269c7df6fa892ed9eb050139af77f2d50ec9408d99027da88f3b4b"

  url "https:github.comadobe-fontssource-han-code-jparchiverefstags#{version}.tar.gz"
  name "Source Han Code JP"
  homepage "https:github.comadobe-fontssource-han-code-jp"

  no_autobump! because: :requires_manual_review

  font "source-han-code-jp-#{version}OTFSourceHanCodeJP-Bold.otf"
  font "source-han-code-jp-#{version}OTFSourceHanCodeJP-BoldIt.otf"
  font "source-han-code-jp-#{version}OTFSourceHanCodeJP-ExtraLight.otf"
  font "source-han-code-jp-#{version}OTFSourceHanCodeJP-ExtraLightIt.otf"
  font "source-han-code-jp-#{version}OTFSourceHanCodeJP-Heavy.otf"
  font "source-han-code-jp-#{version}OTFSourceHanCodeJP-HeavyIt.otf"
  font "source-han-code-jp-#{version}OTFSourceHanCodeJP-Light.otf"
  font "source-han-code-jp-#{version}OTFSourceHanCodeJP-LightIt.otf"
  font "source-han-code-jp-#{version}OTFSourceHanCodeJP-Medium.otf"
  font "source-han-code-jp-#{version}OTFSourceHanCodeJP-MediumIt.otf"
  font "source-han-code-jp-#{version}OTFSourceHanCodeJP-Normal.otf"
  font "source-han-code-jp-#{version}OTFSourceHanCodeJP-NormalIt.otf"
  font "source-han-code-jp-#{version}OTFSourceHanCodeJP-Regular.otf"
  font "source-han-code-jp-#{version}OTFSourceHanCodeJP-RegularIt.otf"

  # No zap stanza required
end