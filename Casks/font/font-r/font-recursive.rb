cask "font-recursive" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrecursiveRecursive%5BCASL%2CCRSV%2CMONO%2Cslnt%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Recursive"
  homepage "https:fonts.google.comspecimenRecursive"

  font "Recursive[CASL,CRSV,MONO,slnt,wght].ttf"

  # No zap stanza required
end