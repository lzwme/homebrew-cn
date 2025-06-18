cask "font-cascadia-mono-nf" do
  version "2407.24"
  sha256 "e67a68ee3386db63f48b9054bd196ea752bc6a4ebb4df35adce6733da50c8474"

  url "https:github.commicrosoftcascadia-codereleasesdownloadv#{version}CascadiaCode-#{version}.zip"
  name "Cascadia Mono NF"
  homepage "https:github.commicrosoftcascadia-code"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  font "ttfCascadiaMonoNF.ttf"
  font "ttfCascadiaMonoNFItalic.ttf"

  # No zap stanza required
end