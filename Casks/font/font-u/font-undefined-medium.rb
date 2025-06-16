cask "font-undefined-medium" do
  version "1.3"
  sha256 "a5e6682e165e70e10b575a468c00013038ec60bad4f1daa9cfb8415d3ce4d84d"

  url "https:github.comandirueckelundefined-mediumarchiverefstagsv#{version}.tar.gz"
  name "undefined medium"
  homepage "https:github.comandirueckelundefined-medium"

  no_autobump! because: :requires_manual_review

  font "undefined-medium-#{version}fontsotfundefined-medium.otf"

  # No zap stanza required
end