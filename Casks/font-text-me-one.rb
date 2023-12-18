cask "font-text-me-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltextmeoneTextMeOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Text Me One"
  homepage "https:fonts.google.comspecimenText+Me+One"

  font "TextMeOne-Regular.ttf"

  # No zap stanza required
end