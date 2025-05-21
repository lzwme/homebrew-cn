cask "livebook" do
  version "0.16.0"
  sha256 "972ae84ff7a6c3f48d5812dd1a33374c0fc454ba76dd145cce5e7950d1fc5d4b"

  url "https:github.comlivebook-devlivebookreleasesdownloadv#{version}LivebookInstall-macos-universal.dmg",
      verified: "github.comlivebook-devlivebook"
  name "Livebook"
  desc "Code notebooks for Elixir developers"
  homepage "https:livebook.dev"

  app "Livebook.app"

  zap trash: "~LibraryApplication Supportlivebook"
end