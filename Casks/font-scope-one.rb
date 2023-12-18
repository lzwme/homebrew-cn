cask "font-scope-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflscopeoneScopeOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Scope One"
  homepage "https:fonts.google.comspecimenScope+One"

  font "ScopeOne-Regular.ttf"

  # No zap stanza required
end