cask "livebook" do
  version "0.15.0"
  sha256 "5dce6ac5358e9de44ebcaa615289f506bb27c7e9d9244c03e5bca176dc16e5a9"

  url "https:github.comlivebook-devlivebookreleasesdownloadv#{version}LivebookInstall-macos-universal.dmg",
      verified: "github.comlivebook-devlivebook"
  name "Livebook"
  desc "Code notebooks for Elixir developers"
  homepage "https:livebook.dev"

  app "Livebook.app"

  zap trash: "~LibraryApplication Supportlivebook"
end