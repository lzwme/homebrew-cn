cask "font-nanum-pen-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnanumpenscriptNanumPenScript-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Nanum Pen Script"
  homepage "https:fonts.google.comspecimenNanum+Pen+Script"

  font "NanumPenScript-Regular.ttf"

  # No zap stanza required
end