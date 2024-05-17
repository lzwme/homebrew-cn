cask "font-mallanna" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmallannaMallanna-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Mallanna"
  homepage "https:fonts.google.comspecimenMallanna"

  font "Mallanna-Regular.ttf"

  # No zap stanza required
end