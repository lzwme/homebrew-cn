cask "livebook" do
  version "0.15.2"
  sha256 "6c3d9b6840722a3a29cf492a9ede1892516390bb89a95d246b8d3710ef57eeb8"

  url "https:github.comlivebook-devlivebookreleasesdownloadv#{version}LivebookInstall-macos-universal.dmg",
      verified: "github.comlivebook-devlivebook"
  name "Livebook"
  desc "Code notebooks for Elixir developers"
  homepage "https:livebook.dev"

  app "Livebook.app"

  zap trash: "~LibraryApplication Supportlivebook"
end