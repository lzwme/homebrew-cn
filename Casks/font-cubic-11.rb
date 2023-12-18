cask "font-cubic-11" do
  version "1.100"
  sha256 "354247bb7e48b2e3896758e7c3413f7ce4329d130b0c9a7ef124d476ca66f4ae"

  url "https:github.comACh-KCubic-11releasesdownloadv#{version}Cubic_11.zip"
  name "Cubic 11"
  name "俐方體11號"
  desc "Open-source 11x11 Traditional Chinese bitmap font"
  homepage "https:github.comACh-KCubic-11"

  font "fontsttfCubic_11_#{version}_R.ttf"

  # No zap stanza required
end