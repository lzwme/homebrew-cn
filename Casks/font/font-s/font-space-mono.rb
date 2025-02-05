cask "font-space-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsspacemonoarchiverefsheadsmaster.tar.gz"
  name "Space Mono"
  homepage "https:github.comgooglefontsspacemono"

  font "spacemono-mainfontsttfSpaceMono-Bold.ttf"
  font "spacemono-mainfontsttfSpaceMono-BoldItalic.ttf"
  font "spacemono-mainfontsttfSpaceMono-Italic.ttf"
  font "spacemono-mainfontsttfSpaceMono-Regular.ttf"

  # No zap stanza required
end