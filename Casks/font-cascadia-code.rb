cask "font-cascadia-code" do
  version "2111.01"
  sha256 "51fd68176dffb87e2fbc79381aef7f5c9488b58918dee223cd7439b5aa14e712"

  url "https:github.commicrosoftcascadia-codereleasesdownloadv#{version}CascadiaCode-#{version}.zip"
  name "Cascadia Code"
  desc "Monospaced font that includes programming ligatures"
  homepage "https:github.commicrosoftcascadia-code"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "ttfCascadiaCode.ttf"
  font "ttfCascadiaCodeItalic.ttf"

  # No zap stanza required
end