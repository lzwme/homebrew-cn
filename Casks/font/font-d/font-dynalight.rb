cask "font-dynalight" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldynalightDynalight-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Dynalight"
  homepage "https:fonts.google.comspecimenDynalight"

  font "Dynalight-Regular.ttf"

  # No zap stanza required
end