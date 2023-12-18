cask "font-kaisei-opti" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflkaiseiopti"
  name "Kaisei Opti"
  desc "Modern style japanese typeface"
  homepage "https:fonts.google.comspecimenKaisei+Opti"

  font "KaiseiOpti-Bold.ttf"
  font "KaiseiOpti-Medium.ttf"
  font "KaiseiOpti-Regular.ttf"

  # No zap stanza required
end