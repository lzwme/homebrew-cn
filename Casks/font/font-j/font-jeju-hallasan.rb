cask "font-jeju-hallasan" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofljejuhallasanJejuHallasan-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Jeju Hallasan"
  homepage "https:fonts.google.comearlyaccess"

  font "JejuHallasan-Regular.ttf"

  # No zap stanza required
end