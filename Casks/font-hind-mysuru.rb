cask "font-hind-mysuru" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflhindmysuru"
  name "Hind Mysuru"
  homepage "https:github.comitfoundryhind-mysuru"

  font "HindMysuru-Bold.ttf"
  font "HindMysuru-Light.ttf"
  font "HindMysuru-Medium.ttf"
  font "HindMysuru-Regular.ttf"
  font "HindMysuru-SemiBold.ttf"

  # No zap stanza required
end