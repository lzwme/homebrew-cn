cask "font-maple" do
  # Check on next version bump if the `container` stanza can be removed
  version "6.4"
  sha256 "7f07c594d6da5971428dc9e8ecd2b7759a80cec1cb87dadd1a44aadbac5cf6ac"

  url "https:github.comsubframe7536Maple-fontreleasesdownloadv#{version}MapleMono-otf.zip"
  name "Maple Mono"
  desc "Nerd Font font with round corners"
  homepage "https:github.comsubframe7536Maple-font"

  livecheck do
    url :url
    strategy :github_latest
  end

  container type: :tar

  font "MapleMono-Bold.otf"
  font "MapleMono-BoldItalic.otf"
  font "MapleMono-Italic.otf"
  font "MapleMono-Light.otf"
  font "MapleMono-LightItalic.otf"
  font "MapleMono-Regular.otf"

  # No zap stanza required
end