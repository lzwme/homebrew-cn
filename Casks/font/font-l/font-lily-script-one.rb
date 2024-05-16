cask "font-lily-script-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllilyscriptoneLilyScriptOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Lily Script One"
  homepage "https:fonts.google.comspecimenLily+Script+One"

  font "LilyScriptOne-Regular.ttf"

  # No zap stanza required
end