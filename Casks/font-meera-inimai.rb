cask "font-meera-inimai" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmeerainimaiMeeraInimai-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Meera Inimai"
  homepage "https:fonts.google.comspecimenMeera+Inimai"

  font "MeeraInimai-Regular.ttf"

  # No zap stanza required
end