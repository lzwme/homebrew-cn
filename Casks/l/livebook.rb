cask "livebook" do
  version "0.11.4"
  sha256 "566a9ea21ceb982020f4171347689bb175d252929914e0089063854d14d12ec2"

  url "https:github.comlivebook-devlivebookreleasesdownloadv#{version}LivebookInstall-v#{version}-macos-universal.dmg",
      verified: "github.comlivebook-devlivebook"
  name "Livebook"
  desc "Code notebooks for Elixir developers"
  homepage "https:livebook.dev"

  app "Livebook.app"

  zap trash: "~LibraryApplication Supportlivebook"
end