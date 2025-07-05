cask "font-space-grotesk" do
  version "2.0.0"
  sha256 "53b415577d4139248555300710bea0d268c7a5be67b93de53b716a9736cabffd"

  url "https://ghfast.top/https://github.com/floriankarsten/space-grotesk/releases/download/#{version}/SpaceGrotesk-#{version}.zip"
  name "Space Grotesk"
  homepage "https://github.com/floriankarsten/space-grotesk"

  no_autobump! because: :requires_manual_review

  font "SpaceGrotesk-#{version}/otf/SpaceGrotesk-Bold.otf"
  font "SpaceGrotesk-#{version}/otf/SpaceGrotesk-Light.otf"
  font "SpaceGrotesk-#{version}/otf/SpaceGrotesk-Medium.otf"
  font "SpaceGrotesk-#{version}/otf/SpaceGrotesk-Regular.otf"

  # No zap stanza required
end