cask "font-delugia-powerline" do
  version "2404.23"
  sha256 "4baf2f2a151eda7559f7cac7c378768ca5a80ce7b79b0fb3f93a87ff9f5b79ca"

  url "https://ghfast.top/https://github.com/adam7/delugia-code/releases/download/v#{version}/delugia-powerline.zip"
  name "Delugia Code"
  homepage "https://github.com/adam7/delugia-code"

  no_autobump! because: :requires_manual_review

  font "delugia-powerline/DelugiaPL-Bold.ttf"
  font "delugia-powerline/DelugiaPL-BoldItalic.ttf"
  font "delugia-powerline/DelugiaPL-Italic.ttf"
  font "delugia-powerline/DelugiaPL.ttf"
  font "delugia-powerline/DelugiaPLLight-Italic.ttf"
  font "delugia-powerline/DelugiaPLLight.ttf"

  # No zap stanza required
end