cask "font-cascadia-mono" do
  version "2111.01"
  sha256 "51fd68176dffb87e2fbc79381aef7f5c9488b58918dee223cd7439b5aa14e712"

  url "https:github.commicrosoftcascadia-codereleasesdownloadv#{version}CascadiaCode-#{version}.zip"
  name "Cascadia Mono"
  desc "Version of Cascadia Code without ligatures"
  homepage "https:github.commicrosoftcascadia-code"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "ttfCascadiaMono.ttf"
  font "ttfCascadiaMonoItalic.ttf"

  # No zap stanza required
end