cask "livebook" do
  version "0.16.1"
  sha256 "2fd289d40604d41acd807b568f5fdea67178c55f74f807ffc403c91c106248dd"

  url "https:github.comlivebook-devlivebookreleasesdownloadv#{version}LivebookInstall-macos-universal.dmg",
      verified: "github.comlivebook-devlivebook"
  name "Livebook"
  desc "Code notebooks for Elixir developers"
  homepage "https:livebook.dev"

  app "Livebook.app"

  zap trash: "~LibraryApplication Supportlivebook"
end