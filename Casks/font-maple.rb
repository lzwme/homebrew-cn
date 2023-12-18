cask "font-maple" do
  version "6.3"
  sha256 "029e0ec0ffd0185cfdfb19f5dab7a489ad7fa7047166fbfe1fe6666625dcc5c6"

  url "https:github.comsubframe7536Maple-fontreleasesdownloadv#{version}MapleMono.zip"
  name "Maple Mono"
  desc "Nerd Font font with round corners"
  homepage "https:github.comsubframe7536Maple-font"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "ttfMapleMono-Bold.ttf"
  font "ttfMapleMono-BoldItalic.ttf"
  font "ttfMapleMono-Italic.ttf"
  font "ttfMapleMono-Regular.ttf"

  # No zap stanza required
end