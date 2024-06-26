cask "font-space-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsspacemonoarchiverefsheadsmaster.tar.gz"
  name "Space Mono"
  homepage "https:github.comgooglefontsspacemono"

  font "spacemono-mainfontsSpaceMono-Bold.ttf"
  font "spacemono-mainfontsSpaceMono-BoldItalic.ttf"
  font "spacemono-mainfontsSpaceMono-Italic.ttf"
  font "spacemono-mainfontsSpaceMono-Regular.ttf"

  # No zap stanza required
end