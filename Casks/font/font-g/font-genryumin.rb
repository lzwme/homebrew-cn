cask "font-genryumin" do
  version "1.501"
  sha256 "e0ddfef92cd319e829fb968a44ce17301e5b35a727824b3c03e3aa9d946e25cd"

  url "https:github.comButTaiwangenryu-fontreleasesdownloadv#{version}GenRyuMin.zip"
  name "GenRyuMin"
  homepage "https:github.comButTaiwangenryu-font"

  font "GenRyuMin-B.ttc"
  font "GenRyuMin-EL.ttc"
  font "GenRyuMin-H.ttc"
  font "GenRyuMin-L.ttc"
  font "GenRyuMin-M.ttc"
  font "GenRyuMin-R.ttc"
  font "GenRyuMin-SB.ttc"

  # No zap stanza required
end