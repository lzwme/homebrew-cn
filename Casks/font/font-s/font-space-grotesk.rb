cask "font-space-grotesk" do
  version "2.0.0"
  sha256 "53b415577d4139248555300710bea0d268c7a5be67b93de53b716a9736cabffd"

  url "https:github.comfloriankarstenspace-groteskreleasesdownload#{version}SpaceGrotesk-#{version}.zip"
  name "Space Grotesk"
  homepage "https:github.comfloriankarstenspace-grotesk"

  no_autobump! because: :requires_manual_review

  font "SpaceGrotesk-#{version}otfSpaceGrotesk-Bold.otf"
  font "SpaceGrotesk-#{version}otfSpaceGrotesk-Light.otf"
  font "SpaceGrotesk-#{version}otfSpaceGrotesk-Medium.otf"
  font "SpaceGrotesk-#{version}otfSpaceGrotesk-Regular.otf"

  # No zap stanza required
end