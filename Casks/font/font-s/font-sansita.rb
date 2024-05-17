cask "font-sansita" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsansita"
  name "Sansita"
  homepage "https:fonts.google.comspecimenSansita"

  font "Sansita-Black.ttf"
  font "Sansita-BlackItalic.ttf"
  font "Sansita-Bold.ttf"
  font "Sansita-BoldItalic.ttf"
  font "Sansita-ExtraBold.ttf"
  font "Sansita-ExtraBoldItalic.ttf"
  font "Sansita-Italic.ttf"
  font "Sansita-Regular.ttf"

  # No zap stanza required
end