cask "font-redressed" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapacheredressedRedressed-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Redressed"
  homepage "https:fonts.google.comspecimenRedressed"

  font "Redressed-Regular.ttf"

  # No zap stanza required
end