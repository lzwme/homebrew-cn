cask "font-fasthand" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfasthandFasthand-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Fasthand"
  homepage "https:fonts.google.comspecimenFasthand"

  font "Fasthand-Regular.ttf"

  # No zap stanza required
end