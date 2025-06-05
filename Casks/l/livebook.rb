cask "livebook" do
  version "0.16.2"
  sha256 "195b40377cb6857eabc6cba0a6d76000adbeec94fbc10aac9ba011801ed1154b"

  url "https:github.comlivebook-devlivebookreleasesdownloadv#{version}LivebookInstall-macos-universal.dmg",
      verified: "github.comlivebook-devlivebook"
  name "Livebook"
  desc "Code notebooks for Elixir developers"
  homepage "https:livebook.dev"

  app "Livebook.app"

  zap trash: "~LibraryApplication Supportlivebook"
end