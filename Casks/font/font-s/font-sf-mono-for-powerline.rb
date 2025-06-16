cask "font-sf-mono-for-powerline" do
  version "16.0d1e1"
  sha256 "33e62fca8e7f901b478e29942e7eee281455e2f16d22cc32ec8572f4fafe5e4b"

  url "https:github.comTwixesSF-Mono-Powerlinearchiverefstagsv#{version}.tar.gz"
  name "SF Mono for Powerline"
  homepage "https:github.comTwixesSF-Mono-Powerline"

  no_autobump! because: :requires_manual_review

  font "SF-Mono-Powerline-#{version}SF-Mono-Powerline-Bold.otf"
  font "SF-Mono-Powerline-#{version}SF-Mono-Powerline-Bold-Italic.otf"
  font "SF-Mono-Powerline-#{version}SF-Mono-Powerline-Heavy.otf"
  font "SF-Mono-Powerline-#{version}SF-Mono-Powerline-Heavy-Italic.otf"
  font "SF-Mono-Powerline-#{version}SF-Mono-Powerline-Light.otf"
  font "SF-Mono-Powerline-#{version}SF-Mono-Powerline-Light-Italic.otf"
  font "SF-Mono-Powerline-#{version}SF-Mono-Powerline-Medium.otf"
  font "SF-Mono-Powerline-#{version}SF-Mono-Powerline-Medium-Italic.otf"
  font "SF-Mono-Powerline-#{version}SF-Mono-Powerline-Regular.otf"
  font "SF-Mono-Powerline-#{version}SF-Mono-Powerline-Regular-Italic.otf"
  font "SF-Mono-Powerline-#{version}SF-Mono-Powerline-Semibold.otf"
  font "SF-Mono-Powerline-#{version}SF-Mono-Powerline-Semibold-Italic.otf"

  # No zap stanza required
end