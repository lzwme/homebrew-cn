cask "livebook" do
  version "0.13.2"
  sha256 "b0e7eee4f9bd5bd6f5ad599b271c1b083580a7a58b2e78753cd62075473d0d96"

  url "https:github.comlivebook-devlivebookreleasesdownloadv#{version}LivebookInstall-v#{version}-macos-universal.dmg",
      verified: "github.comlivebook-devlivebook"
  name "Livebook"
  desc "Code notebooks for Elixir developers"
  homepage "https:livebook.dev"

  app "Livebook.app"

  zap trash: "~LibraryApplication Supportlivebook"
end