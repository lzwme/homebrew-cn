cask "font-genyogothic" do
  version "2.100"
  sha256 "770cff05d612a400f9cc27bb11998d73225d80669bf23d6423545252178a7ffe"

  url "https:github.comButTaiwangenyog-fontreleasesdownloadv#{version}GenYoGothic#{version.major}-ttc.zip"
  name "GenYoGothic"
  name "源樣黑體"
  homepage "https:github.comButTaiwangenyog-font"

  font "GenYoGothic#{version.major}-B.ttc"
  font "GenYoGothic#{version.major}-EL.ttc"
  font "GenYoGothic#{version.major}-H.ttc"
  font "GenYoGothic#{version.major}-L.ttc"
  font "GenYoGothic#{version.major}-M.ttc"
  font "GenYoGothic#{version.major}-N.ttc"
  font "GenYoGothic#{version.major}-R.ttc"

  # No zap stanza required
end