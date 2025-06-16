cask "font-leland" do
  version "0.78"
  sha256 "7f213f57afb05fbd6d2fa5aa4a785782448ae560c11d79a0afdfb5e2784a0495"

  url "https:github.comMuseScoreFontsLelandarchiverefstagsv#{version}.tar.gz"
  name "Leland"
  homepage "https:github.comMuseScoreFontsLeland"

  no_autobump! because: :requires_manual_review

  font "Leland-#{version}Leland.otf"
  font "Leland-#{version}LelandText.otf"
  artifact "Leland-#{version}leland_metadata.json", target: "LibraryApplication SupportSMuFLFontsLelandLeland.json"

  # No zap stanza required
end