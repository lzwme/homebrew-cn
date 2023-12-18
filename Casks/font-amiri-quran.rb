cask "font-amiri-quran" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflamiriquranAmiriQuran-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Amiri Quran"
  homepage "https:fonts.google.comspecimenAmiri+Quran"

  font "AmiriQuran-Regular.ttf"

  # No zap stanza required
end