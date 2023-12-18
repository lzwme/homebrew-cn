cask "font-federo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfederoFedero-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Federo"
  homepage "https:fonts.google.comspecimenFedero"

  font "Federo-Regular.ttf"

  # No zap stanza required
end