cask "neovide" do
  version "0.11.2"
  sha256 "23a6c829094a02d69f1b302b0b3883e91b5725b19f0e3140f35dfe3bf296e988"

  url "https:github.comneovideneovidereleasesdownload#{version}Neovide.dmg.zip"
  name "neovide"
  desc "Neovim Client"
  homepage "https:github.comneovideneovide"

  depends_on formula: "neovim"

  app "Neovide.app"
  binary "#{appdir}Neovide.appContentsMacOSneovide"

  zap trash: "~LibrarySaved Application Statecom.neovide.neovide"
end