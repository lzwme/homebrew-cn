cask "font-julius-sans-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofljuliussansoneJuliusSansOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Julius Sans One"
  homepage "https:fonts.google.comspecimenJulius+Sans+One"

  font "JuliusSansOne-Regular.ttf"

  # No zap stanza required
end