cask "doteditor" do
  version "0.3.1"
  sha256 "06e60c4e474bbca2246804140d73d3faeec7a984759a0fca6d47e07d5994dbcf"

  url "https:github.comvincenthEEDotEditorreleasesdownloadv#{version}DotEditor.#{version}.dmg",
      verified: "github.comvincenthEEDotEditor"
  name "DotEditor"
  desc "GUI editor for dot language used in graphviz"
  homepage "https:vincenthee.github.ioDotEditor"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-09-08", because: :unmaintained

  depends_on formula: "graphviz"

  app "DotEditor.app"

  caveats do
    requires_rosetta
  end
end