cask "livebook" do
  version "0.12.0"
  sha256 "5bf531428f700308a5c8437cb988e80f9049126448612edb1d79fbe0aea8d2ab"

  url "https:github.comlivebook-devlivebookreleasesdownloadv#{version}LivebookInstall-v#{version}-macos-universal.dmg",
      verified: "github.comlivebook-devlivebook"
  name "Livebook"
  desc "Code notebooks for Elixir developers"
  homepage "https:livebook.dev"

  app "Livebook.app"

  zap trash: "~LibraryApplication Supportlivebook"
end