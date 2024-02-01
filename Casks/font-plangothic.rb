cask "font-plangothic" do
  version "1.8.5757"
  sha256 "85b2b1a0ad8274e76794ebb330e12a3e62e638d8df8d35679d078b18af6900ba"

  url "https:github.comFitzgerald-Porthmouth-KoenigseggPlangothic-ProjectarchiverefstagsV#{version}.zip"
  name "Plangothic"
  desc "Plangothic is a sans-serif font that covers CJK Unified Ideographs"
  homepage "https:github.comFitzgerald-Porthmouth-KoenigseggPlangothic-Project"

  font "Plangothic-Project-#{version}PlangothicP1-Regular (allideo).ttf"
  font "Plangothic-Project-#{version}PlangothicP2-Regular.ttf"

  # No zap stanza required
end