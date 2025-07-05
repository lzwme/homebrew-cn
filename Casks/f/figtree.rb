cask "figtree" do
  version "1.4.4"
  sha256 "4a11741143982a9b7fea78e60c8315ce8e8436eeb96ab3ee5376c53c83e54b9b"

  url "https://ghfast.top/https://github.com/rambaut/figtree/releases/download/v#{version}/FigTree.v#{version}.dmg"
  name "FigTree"
  desc "Phylogenetic tree viewer"
  homepage "https://github.com/rambaut/figtree/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2025-03-02", because: :unmaintained

  app "FigTree v#{version}.app"
  qlplugin "QuickLook Plugin/FigTreeQuickLookPlugin.qlgenerator"

  caveats do
    requires_rosetta
  end
end