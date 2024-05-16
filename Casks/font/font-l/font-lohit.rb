cask "font-lohit" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllohitdevanagariLohit-Devanagari.ttf",
      verified: "github.comgooglefonts"
  name "Lohit"
  homepage "https:fonts.google.comearlyaccess"

  font "Lohit-Devanagari.ttf"

  # No zap stanza required
end