cask "font-church-slavonic" do
  version "2.2.1"
  sha256 "6fd44c6fb4fecc01ecea8dda6efc18bf46646f2e5d997c7d60e0cbae3aa8ff2e"

  url "https:github.comtypiconmanfonts-cureleasesdownloadv#{version}fonts-churchslavonic.zip"
  name "Church Slavonic Fonts"
  homepage "https:github.comtypiconmanfonts-cu"

  no_autobump! because: :requires_manual_review

  font "fonts-churchslavonicAcathist-Regular.otf"
  font "fonts-churchslavonicCathismaUnicode.otf"
  font "fonts-churchslavonicFedorovskUnicode.otf"
  font "fonts-churchslavonicIndictionUnicode.otf"
  font "fonts-churchslavonicMenaionUnicode.otf"
  font "fonts-churchslavonicMezenetsUnicode.otf"
  font "fonts-churchslavonicMonomakhUnicode.otf"
  font "fonts-churchslavonicOglavieUnicode.otf"
  font "fonts-churchslavonicPochaevskUnicode.otf"
  font "fonts-churchslavonicPomorskyUnicode.otf"
  font "fonts-churchslavonicPonomarUnicode.otf"
  font "fonts-churchslavonicShafarik-Regular.otf"
  font "fonts-churchslavonicTriodionUnicode.otf"
  font "fonts-churchslavonicVertogradUnicode.otf"
  font "fonts-churchslavonicVoskresensky-Regular.otf"

  # No zap stanza required
end