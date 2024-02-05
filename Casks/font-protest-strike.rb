cask "font-protest-strike" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflproteststrikeProtestStrike-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Protest Strike"
  desc "Solid but peaceful sans serif typeface"
  homepage "https:fonts.google.comspecimenProtest+Strike"

  font "ProtestStrike-Regular.ttf"

  # No zap stanza required
end