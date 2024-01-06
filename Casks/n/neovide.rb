cask "neovide" do
  version "0.12.1"
  sha256 "3514cba136852ae78130b8ee5dc7db8994d7de1a074fd0b029f0a58435edff75"

  url "https:github.comneovideneovidereleasesdownload#{version}Neovide.dmg.zip"
  name "neovide"
  desc "Neovim Client"
  homepage "https:github.comneovideneovide"

  depends_on formula: "neovim"

  app "Neovide.app"
  binary "#{appdir}Neovide.appContentsMacOSneovide"

  zap trash: "~LibrarySaved Application Statecom.neovide.neovide"
end