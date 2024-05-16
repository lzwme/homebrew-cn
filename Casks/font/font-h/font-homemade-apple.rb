cask "font-homemade-apple" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapachehomemadeappleHomemadeApple-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Homemade Apple"
  homepage "https:fonts.google.comspecimenHomemade+Apple"

  font "HomemadeApple-Regular.ttf"

  # No zap stanza required
end