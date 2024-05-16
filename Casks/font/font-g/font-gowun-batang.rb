cask "font-gowun-batang" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflgowunbatang"
  name "Gowun Batang"
  homepage "https:fonts.google.comspecimenGowun+Batang"

  font "GowunBatang-Bold.ttf"
  font "GowunBatang-Regular.ttf"

  # No zap stanza required
end