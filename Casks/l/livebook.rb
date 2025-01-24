cask "livebook" do
  version "0.14.6"
  sha256 "cf9ef7c8c81a98177e193080233c256234be7fd861a350f557ccc8fd1f895052"

  url "https:github.comlivebook-devlivebookreleasesdownloadv#{version}LivebookInstall-macos-universal.dmg",
      verified: "github.comlivebook-devlivebook"
  name "Livebook"
  desc "Code notebooks for Elixir developers"
  homepage "https:livebook.dev"

  app "Livebook.app"

  zap trash: "~LibraryApplication Supportlivebook"
end