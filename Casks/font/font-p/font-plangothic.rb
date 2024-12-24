cask "font-plangothic" do
  version "1.9.5769"
  sha256 "d58680d8a71ab80ec47bb6ce6d896cd528d01a7ee782298d312e2c4883d54a7e"

  url "https:github.comFitzgerald-Porthmouth-KoenigseggPlangothic-ProjectarchiverefstagsV#{version}.tar.gz"
  name "Plangothic"
  homepage "https:github.comFitzgerald-Porthmouth-KoenigseggPlangothic-Project"

  font "Plangothic_Project-#{version}PlangothicP1-Regular (allideo).otf"
  font "Plangothic_Project-#{version}PlangothicP1-Regular (fallback).otf"
  font "Plangothic_Project-#{version}PlangothicP2-Regular.otf"

  # No zap stanza required
end