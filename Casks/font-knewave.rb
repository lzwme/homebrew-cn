cask "font-knewave" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflknewaveKnewave-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Knewave"
  homepage "https:fonts.google.comspecimenKnewave"

  font "Knewave-Regular.ttf"

  # No zap stanza required
end