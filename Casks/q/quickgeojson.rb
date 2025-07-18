cask "quickgeojson" do
  version "1.1"
  sha256 "48a30865f3183c086c9ac70003276e2356c2fd4468e8818b0b2ec5adb3366332"

  url "https://ghfast.top/https://github.com/irees/quickgeojson/releases/download/v#{version}/quickgeojson.qlgenerator.zip"
  name "quickgeojson"
  desc "Quick Look plugin for GeoJSON and TopoJSON"
  homepage "https://github.com/irees/quickgeojson"

  no_autobump! because: :requires_manual_review

  qlplugin "quickgeojson.qlgenerator"

  # No zap stanza required
end