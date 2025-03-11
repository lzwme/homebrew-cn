cask "livebook" do
  version "0.15.3"
  sha256 "8cb87cb8562ea2892f5d0bf303d4f09fad971ebc605b651bc5494fcc07957d16"

  url "https:github.comlivebook-devlivebookreleasesdownloadv#{version}LivebookInstall-macos-universal.dmg",
      verified: "github.comlivebook-devlivebook"
  name "Livebook"
  desc "Code notebooks for Elixir developers"
  homepage "https:livebook.dev"

  app "Livebook.app"

  zap trash: "~LibraryApplication Supportlivebook"
end