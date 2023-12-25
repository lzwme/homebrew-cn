cask "neovide" do
  version "0.12.0"
  sha256 "3eb9d0487b30a966251ebde4c0a68fd65ca11b2a0eaed7fb1dba79d866ced86e"

  url "https:github.comneovideneovidereleasesdownload#{version}Neovide.dmg.zip"
  name "neovide"
  desc "Neovim Client"
  homepage "https:github.comneovideneovide"

  depends_on formula: "neovim"

  app "Neovide.app"
  binary "#{appdir}Neovide.appContentsMacOSneovide"

  zap trash: "~LibrarySaved Application Statecom.neovide.neovide"
end