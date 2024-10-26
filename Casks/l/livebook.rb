cask "livebook" do
  version "0.14.5"
  sha256 "e82926e11638775812d4c2ae5ee55396f20c485fb8e5c29a6d60ab43b8850a25"

  url "https:github.comlivebook-devlivebookreleasesdownloadv#{version}LivebookInstall-macos-universal.dmg",
      verified: "github.comlivebook-devlivebook"
  name "Livebook"
  desc "Code notebooks for Elixir developers"
  homepage "https:livebook.dev"

  app "Livebook.app"

  zap trash: "~LibraryApplication Supportlivebook"
end