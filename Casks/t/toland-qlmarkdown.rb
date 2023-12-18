cask "toland-qlmarkdown" do
  version "1.3.6"
  sha256 "810853c000dd5c3e18978070abb7f595ad52ddfa568fccb428d28b513d1810ab"

  url "https:github.comtolandqlmarkdownreleasesdownloadv#{version}QLMarkdown.qlgenerator.zip"
  name "QLMarkdown"
  desc "QuickLook generator for Markdown files"
  homepage "https:github.comtolandqlmarkdown"

  qlplugin "QLMarkdown.qlgenerator"

  # No zap stanza required

  caveats do
    discontinued
  end
end