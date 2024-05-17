cask "font-pushster" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpushsterPushster-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Pushster"
  homepage ""

  font "Pushster-Regular.ttf"

  # No zap stanza required
end