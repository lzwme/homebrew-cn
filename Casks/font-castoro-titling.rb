cask "font-castoro-titling" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcastorotitlingCastoroTitling-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Castoro Titling"
  homepage "https:fonts.google.comspecimenCastoro+Titling"

  font "CastoroTitling-Regular.ttf"

  # No zap stanza required
end