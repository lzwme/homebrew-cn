cask "browserosaurus" do
  arch arm: "arm64", intel: "x64"

  version "20.9.1"
  sha256 arm:   "8b0192609e43a3038610ae75bc001a3c46bbf3df6805c97d0368c80e528a5054",
         intel: "56cfa0a35795232cce6f11bd5c88333d3f48a89fc334b67b33825d0f959f25f4"

  url "https:github.comwill-stonebrowserosaurusreleasesdownloadv#{version}Browserosaurus-darwin-#{arch}-#{version}.zip"
  name "Browserosaurus"
  desc "Open-source browser prompter"
  homepage "https:github.comwill-stonebrowserosaurus"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Browserosaurus.app"

  uninstall quit: "com.browserosaurus"

  zap trash: [
    "~LibraryApplication SupportBrowserosaurus",
    "~LibraryPreferencescom.browserosaurus.plist",
  ]
end