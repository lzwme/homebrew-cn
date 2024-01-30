cask "neovide" do
  version "0.12.2"
  sha256 "7022ecc26c8a5ccc06d114c958c14572075f5b2694f6c69382bb19c09b850350"

  url "https:github.comneovideneovidereleasesdownload#{version}Neovide.dmg.zip"
  name "neovide"
  desc "Neovim Client"
  homepage "https:github.comneovideneovide"

  depends_on formula: "neovim"

  app "Neovide.app"
  binary "#{appdir}Neovide.appContentsMacOSneovide"

  zap trash: "~LibrarySaved Application Statecom.neovide.neovide"
end