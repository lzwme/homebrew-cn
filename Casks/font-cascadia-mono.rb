cask "font-cascadia-mono" do
  version "2404.23"
  sha256 "a911410626c0e09d03fa3fdda827188fda96607df50fecc3c5fee5906e33251b"

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