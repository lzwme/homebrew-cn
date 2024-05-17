cask "font-monoid" do
  version "0.61"
  sha256 :no_check

  url "https:github.comlarsenworkmonoidblobreleaseMonoid.zip?raw=true",
      verified: "github.comlarsenworkmonoid"
  name "Monoid"
  homepage "https:larsenwork.commonoid"

  font "Monoid-Bold.ttf"
  font "Monoid-Italic.ttf"
  font "Monoid-Regular.ttf"
  font "Monoid-Retina.ttf"

  caveats <<~EOS
    #{token} only installs the Normal Weight, Medium LineHeight, with Ligatures variant.
    To get other styles, please tap the sscotthhomebrew-monoid repo
      brew tap sscotthmonoid
  EOS

  # No zap stanza required
end