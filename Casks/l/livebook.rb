cask "livebook" do
  version "0.14.2"
  sha256 "d68903545e116ab32cacb0fb947057429d3cc4b1f1d5ca9342ef9875b819b821"

  url "https:github.comlivebook-devlivebookreleasesdownloadv#{version}LivebookInstall-v#{version}-macos-universal.dmg",
      verified: "github.comlivebook-devlivebook"
  name "Livebook"
  desc "Code notebooks for Elixir developers"
  homepage "https:livebook.dev"

  app "Livebook.app"

  zap trash: "~LibraryApplication Supportlivebook"
end