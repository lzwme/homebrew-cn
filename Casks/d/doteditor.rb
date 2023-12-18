cask "doteditor" do
  version "0.3.1"
  sha256 "06e60c4e474bbca2246804140d73d3faeec7a984759a0fca6d47e07d5994dbcf"

  url "https:github.comvincenthEEDotEditorreleasesdownloadv#{version}DotEditor.#{version}.dmg",
      verified: "github.comvincenthEEDotEditor"
  name "DotEditor"
  homepage "https:vincenthee.github.ioDotEditor"

  depends_on formula: "graphviz"

  app "DotEditor.app"
end