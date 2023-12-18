cask "font-cookie" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcookieCookie-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Cookie"
  homepage "https:fonts.google.comspecimenCookie"

  font "Cookie-Regular.ttf"

  # No zap stanza required
end