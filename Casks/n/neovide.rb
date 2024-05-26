cask "neovide" do
  version "0.13.1"
  sha256 "34f205f483b5794971b8bb1cbe005d330ed5e192d818df8fcea9b9b976af0cf4"

  url "https:github.comneovideneovidereleasesdownload#{version}Neovide.dmg.zip"
  name "neovide"
  desc "Neovim Client"
  homepage "https:github.comneovideneovide"

  depends_on formula: "neovim"

  app "Neovide.app"
  binary "#{appdir}Neovide.appContentsMacOSneovide"

  zap trash: "~LibrarySaved Application Statecom.neovide.neovide"
end