cask "font-intel-one-mono" do
  version "1.3.0"
  sha256 "89921f9171fe1a9955c044b82da40121a096b3b38a984b68f49d92a73bda812b"

  url "https:github.comintelintel-one-monoreleasesdownloadV#{version}otf.zip"
  name "font-intel-one-mono"
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