cask "livebook" do
  version "0.13.0"
  sha256 "e311ed78271aab975f0780e0e681ad38f1e52ec6a82d00475d0aac2ee9f77bd2"

  url "https:github.comlivebook-devlivebookreleasesdownloadv#{version}LivebookInstall-v#{version}-macos-universal.dmg",
      verified: "github.comlivebook-devlivebook"
  name "Livebook"
  desc "Code notebooks for Elixir developers"
  homepage "https:livebook.dev"

  app "Livebook.app"

  zap trash: "~LibraryApplication Supportlivebook"
end