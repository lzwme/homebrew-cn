cask "browserosaurus" do
  arch arm: "arm64", intel: "x64"

  version "20.6.1"
  sha256 arm:   "dddbeb89c20177667dd74e9d7d0f72ec91b3b5d4cbf38f6cc25db265c29f92a1",
         intel: "a1011b937957479d992c6905113c49688d5cc733175d4d3f8e6a46fe29f90110"

  url "https:github.comwill-stonebrowserosaurusreleasesdownloadv#{version}Browserosaurus-darwin-#{arch}-#{version}.zip"
  name "Browserosaurus"
  desc "Open-source browser prompter"
  homepage "https:github.comwill-stonebrowserosaurus"

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Browserosaurus.app"

  uninstall quit: "com.browserosaurus"

  zap trash: [
    "~LibraryApplication SupportBrowserosaurus",
    "~LibraryPreferencescom.browserosaurus.plist",
  ]
end