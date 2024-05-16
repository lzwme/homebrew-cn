cask "font-lohit-tamil" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllohittamilLohit-Tamil.ttf",
      verified: "github.comgooglefonts"
  name "Lohit Tamil"
  homepage "https:fonts.google.comspecimenLohit+Tamil"

  font "Lohit-Tamil.ttf"

  # No zap stanza required
end