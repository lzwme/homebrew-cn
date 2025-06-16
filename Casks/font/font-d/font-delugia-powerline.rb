cask "font-delugia-powerline" do
  version "2404.23"
  sha256 "4baf2f2a151eda7559f7cac7c378768ca5a80ce7b79b0fb3f93a87ff9f5b79ca"

  url "https:github.comadam7delugia-codereleasesdownloadv#{version}delugia-powerline.zip"
  name "Delugia Code"
  homepage "https:github.comadam7delugia-code"

  no_autobump! because: :requires_manual_review

  font "delugia-powerlineDelugiaPL-Bold.ttf"
  font "delugia-powerlineDelugiaPL-BoldItalic.ttf"
  font "delugia-powerlineDelugiaPL-Italic.ttf"
  font "delugia-powerlineDelugiaPL.ttf"
  font "delugia-powerlineDelugiaPLLight-Italic.ttf"
  font "delugia-powerlineDelugiaPLLight.ttf"

  # No zap stanza required
end