cask "font-tsukimi-rounded" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofltsukimirounded"
  name "Tsukimi Rounded"
  homepage "https:fonts.google.comspecimenTsukimi+Rounded"

  font "TsukimiRounded-Bold.ttf"
  font "TsukimiRounded-Light.ttf"
  font "TsukimiRounded-Medium.ttf"
  font "TsukimiRounded-Regular.ttf"
  font "TsukimiRounded-SemiBold.ttf"

  # No zap stanza required
end