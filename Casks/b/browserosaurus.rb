cask "browserosaurus" do
  arch arm: "arm64", intel: "x64"

  version "20.8.0"
  sha256 arm:   "99c74e18416921be65a9cc2abe07e49b694bde5524187b0a13f4f904017c882f",
         intel: "481049c81b655f8662ecc3e74badfec219e265cdad20c5e1bcec283423b0b73c"

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