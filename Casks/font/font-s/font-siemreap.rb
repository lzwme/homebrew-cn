cask "font-siemreap" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsiemreapSiemreap.ttf",
      verified: "github.comgooglefonts"
  name "Siemreap"
  homepage "https:fonts.google.comspecimenSiemreap"

  font "Siemreap.ttf"

  # No zap stanza required
end