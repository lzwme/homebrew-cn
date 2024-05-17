cask "font-yanone-kaffeesatz" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflyanonekaffeesatzYanoneKaffeesatz%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Yanone Kaffeesatz"
  homepage "https:fonts.google.comspecimenYanone+Kaffeesatz"

  font "YanoneKaffeesatz[wght].ttf"

  # No zap stanza required
end