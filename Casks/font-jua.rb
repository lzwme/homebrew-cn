cask "font-jua" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofljuaJua-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Jua"
  homepage "https:fonts.google.comspecimenJua"

  font "Jua-Regular.ttf"

  # No zap stanza required
end