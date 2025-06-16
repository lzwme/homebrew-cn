cask "font-delugia-mono-complete" do
  version "2404.23"
  sha256 "c731d71580731cf15fe1ff6f742c17b1cfa6a41f44f003b699d39c2b10779add"

  url "https:github.comadam7delugia-codereleasesdownloadv#{version}delugia-mono-complete.zip"
  name "Delugia Code"
  homepage "https:github.comadam7delugia-code"

  no_autobump! because: :requires_manual_review

  font "delugia-mono-completeDelugiaMonoComplete-Bold.ttf"
  font "delugia-mono-completeDelugiaMonoComplete-BoldItalic.ttf"
  font "delugia-mono-completeDelugiaMonoComplete-Italic.ttf"
  font "delugia-mono-completeDelugiaMonoComplete.ttf"
  font "delugia-mono-completeDelugiaMonoCompleteLight-Italic.ttf"
  font "delugia-mono-completeDelugiaMonoCompleteLight.ttf"

  # No zap stanza required
end