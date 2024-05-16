cask "font-lustria" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllustriaLustria-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Lustria"
  homepage "https:fonts.google.comspecimenLustria"

  font "Lustria-Regular.ttf"

  # No zap stanza required
end