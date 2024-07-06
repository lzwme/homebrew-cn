cask "livebook" do
  version "0.13.3"
  sha256 "5875bb0a0430c060e884189512319c70cd0af9d4b95c7a98ab7f7e4c8e70dcf2"

  url "https:github.comlivebook-devlivebookreleasesdownloadv#{version}LivebookInstall-v#{version}-macos-universal.dmg",
      verified: "github.comlivebook-devlivebook"
  name "Livebook"
  desc "Code notebooks for Elixir developers"
  homepage "https:livebook.dev"

  app "Livebook.app"

  zap trash: "~LibraryApplication Supportlivebook"
end