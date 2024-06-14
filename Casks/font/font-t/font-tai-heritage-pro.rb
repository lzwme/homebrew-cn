cask "font-tai-heritage-pro" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofltaiheritagepro"
  name "Tai Heritage Pro"
  homepage "https:fonts.google.comspecimenTai+Heritage+Pro"

  font "TaiHeritagePro-Bold.ttf"
  font "TaiHeritagePro-Regular.ttf"

  # No zap stanza required
end