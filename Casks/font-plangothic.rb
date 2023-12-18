cask "font-plangothic" do
  version "1.8.5752"
  sha256 "215824e52be9de6cf7f89e9768561c14b460ae17ab528100f20472e4587ae3c7"

  url "https:github.comFitzgerald-Porthmouth-KoenigseggPlangothic-ProjectarchiverefstagsV#{version}.zip"
  name "Plangothic"
  desc "Plangothic is a sans-serif font that covers CJK Unified Ideographs"
  homepage "https:github.comFitzgerald-Porthmouth-KoenigseggPlangothic-Project"

  font "Plangothic-Project-#{version}PlangothicP1-Regular (allideo).ttf"
  font "Plangothic-Project-#{version}PlangothicP2-Regular.ttf"

  # No zap stanza required
end