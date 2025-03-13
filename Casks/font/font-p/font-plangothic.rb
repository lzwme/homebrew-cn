cask "font-plangothic" do
  version "2.9.5771"
  sha256 "7cec6a938a3fbd3ef58c9e6f06d32282277d86e17c3634de72f0adf427ad41ca"

  url "https:github.comFitzgerald-Porthmouth-KoenigseggPlangothic-ProjectarchiverefstagsV#{version}.tar.gz"
  name "Plangothic"
  homepage "https:github.comFitzgerald-Porthmouth-KoenigseggPlangothic-Project"

  font "Plangothic_Project-#{version}PlangothicP1-Regular (allideo).otf"
  font "Plangothic_Project-#{version}PlangothicP1-Regular (fallback).otf"
  font "Plangothic_Project-#{version}Plangothic.ttc"

  # No zap stanza required
end