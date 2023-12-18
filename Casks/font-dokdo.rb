cask "font-dokdo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldokdoDokdo-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Dokdo"
  homepage "https:fonts.google.comspecimenDokdo"

  font "Dokdo-Regular.ttf"

  # No zap stanza required
end