cask "font-joan" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofljoanJoan-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Joan"
  homepage "https:fonts.google.comspecimenJoan"

  font "Joan-Regular.ttf"

  # No zap stanza required
end