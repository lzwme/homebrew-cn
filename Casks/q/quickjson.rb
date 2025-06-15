cask "quickjson" do
  version "1.0.0"
  sha256 "874fc0afd431f68527929a0592c23a81b70d53e6032419e540551fccd662cfd2"

  url "https:github.comjohanQuickJSONreleasesdownloadv#{version}QuickJSON.qlgenerator.zip"
  name "QuickJSON"
  desc "Quick Look plugin to pretty-print JSON"
  homepage "https:github.comjohanQuickJSON"

  no_autobump! because: :requires_manual_review

  qlplugin "QuickJSON.qlgenerator"

  # No zap stanza required
end