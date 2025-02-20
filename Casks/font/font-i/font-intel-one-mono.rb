cask "font-intel-one-mono" do
  version "1.4.0"
  sha256 "74ef8ee667403c760745bc12fc5e2cb1684544194fad3d5340919c173a8227fc"

  url "https:github.comintelintel-one-monoreleasesdownloadV#{version}otf.zip"
  name "Intel One Mono"
  homepage "https:github.comintelintel-one-mono"

  font "otfIntelOneMono-Bold.otf"
  font "otfIntelOneMono-BoldItalic.otf"
  font "otfIntelOneMono-Italic.otf"
  font "otfIntelOneMono-Light.otf"
  font "otfIntelOneMono-LightItalic.otf"
  font "otfIntelOneMono-Medium.otf"
  font "otfIntelOneMono-MediumItalic.otf"
  font "otfIntelOneMono-Regular.otf"

  # No zap stanza required
end