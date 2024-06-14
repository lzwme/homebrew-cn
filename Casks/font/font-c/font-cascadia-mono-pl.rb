cask "font-cascadia-mono-pl" do
  version "2404.23"
  sha256 "a911410626c0e09d03fa3fdda827188fda96607df50fecc3c5fee5906e33251b"

  url "https:github.commicrosoftcascadia-codereleasesdownloadv#{version}CascadiaCode-#{version}.zip"
  name "Cascadia Mono PL"
  homepage "https:github.commicrosoftcascadia-code"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "ttfCascadiaMonoPL.ttf"
  font "ttfCascadiaMonoPLItalic.ttf"

  # No zap stanza required
end