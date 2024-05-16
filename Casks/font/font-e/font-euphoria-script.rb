cask "font-euphoria-script" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofleuphoriascriptEuphoriaScript-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Euphoria Script"
  homepage "https:fonts.google.comspecimenEuphoria+Script"

  font "EuphoriaScript-Regular.ttf"

  # No zap stanza required
end