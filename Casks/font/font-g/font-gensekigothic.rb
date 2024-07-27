cask "font-gensekigothic" do
  version "2.000"
  sha256 "08b6ef44aac95cae3e58c780c1d75800640eb1e481982c221fa1bf2ec885cb25"

  url "https:github.comButTaiwangenseki-fontreleasesdownloadv#{version}GenSekiGothic#{version.major}-ttc.zip"
  name "GenSekiGothic"
  homepage "https:github.comButTaiwangenseki-font"

  font "GenSekiGothic#{version.major}-B.ttc"
  font "GenSekiGothic#{version.major}-H.ttc"
  font "GenSekiGothic#{version.major}-L.ttc"
  font "GenSekiGothic#{version.major}-M.ttc"
  font "GenSekiGothic#{version.major}-R.ttc"

  # No zap stanza required
end