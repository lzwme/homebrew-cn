cask "font-lohit-bengali" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllohitbengaliLohit-Bengali.ttf",
      verified: "github.comgooglefonts"
  name "Lohit Bengali"
  homepage "https:fonts.google.comspecimenLohit+Bengali"

  font "Lohit-Bengali.ttf"

  # No zap stanza required
end