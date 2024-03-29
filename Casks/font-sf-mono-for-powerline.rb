cask "font-sf-mono-for-powerline" do
  version :latest
  sha256 :no_check

  url "https:github.comTwixesSF-Mono-Powerlinearchivemaster.zip"
  name "SF Mono for Powerline"
  desc "Apple's SF Mono font patched with the Nerd Fonts patcher for Powerline support"
  homepage "https:github.comTwixesSF-Mono-Powerline"

  font "SF-Mono-Powerline-masterSF-Mono-Powerline-Bold.otf"
  font "SF-Mono-Powerline-masterSF-Mono-Powerline-BoldItalic.otf"
  font "SF-Mono-Powerline-masterSF-Mono-Powerline-Heavy.otf"
  font "SF-Mono-Powerline-masterSF-Mono-Powerline-HeavyItalic.otf"
  font "SF-Mono-Powerline-masterSF-Mono-Powerline-Light.otf"
  font "SF-Mono-Powerline-masterSF-Mono-Powerline-LightItalic.otf"
  font "SF-Mono-Powerline-masterSF-Mono-Powerline-Medium.otf"
  font "SF-Mono-Powerline-masterSF-Mono-Powerline-MediumItalic.otf"
  font "SF-Mono-Powerline-masterSF-Mono-Powerline-Regular.otf"
  font "SF-Mono-Powerline-masterSF-Mono-Powerline-RegularItalic.otf"
  font "SF-Mono-Powerline-masterSF-Mono-Powerline-Semibold.otf"
  font "SF-Mono-Powerline-masterSF-Mono-Powerline-SemiboldItalic.otf"

  # No zap stanza required
end