cask "livebook" do
  version "0.14.4"
  sha256 "9735680b5da4f2cbb672ac0c72adab58c283956649e65cb3ce9c5fd3c3ab5057"

  url "https:github.comlivebook-devlivebookreleasesdownloadv#{version}LivebookInstall-v#{version}-macos-universal.dmg",
      verified: "github.comlivebook-devlivebook"
  name "Livebook"
  desc "Code notebooks for Elixir developers"
  homepage "https:livebook.dev"

  app "Livebook.app"

  zap trash: "~LibraryApplication Supportlivebook"
end