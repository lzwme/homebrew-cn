cask "font-agu-display" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflagudisplayAguDisplay%5BMORF%5D.ttf",
      verified: "github.comgooglefonts"
  name "Agu Display"
  homepage "https:fonts.google.comspecimenAgu+Display"

  font "AguDisplay[MORF].ttf"

  # No zap stanza required
end