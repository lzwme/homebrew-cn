cask "font-jeju-gothic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofljejugothicJejuGothic-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Jeju Gothic"
  homepage "https:fonts.google.comearlyaccess"

  font "JejuGothic-Regular.ttf"

  # No zap stanza required
end