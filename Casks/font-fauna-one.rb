cask "font-fauna-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfaunaoneFaunaOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Fauna One"
  homepage "https:fonts.google.comspecimenFauna+One"

  font "FaunaOne-Regular.ttf"

  # No zap stanza required
end