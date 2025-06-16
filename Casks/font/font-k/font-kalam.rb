cask "font-kalam" do
  version "2.001"
  sha256 "221df2b265d12789af5ef52afd25479ed84eabf7802e59de3de01291b237c605"

  url "https:github.comitfoundrykalamreleasesdownloadv#{version}kalam-#{version.dots_to_underscores}.zip"
  name "Kalam"
  homepage "https:github.comitfoundrykalam"

  no_autobump! because: :requires_manual_review

  font "Kalam-Bold.otf"
  font "Kalam-Light.otf"
  font "Kalam-Regular.otf"

  # No zap stanza required
end