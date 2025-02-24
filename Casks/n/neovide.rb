cask "neovide" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.14.1"
  sha256 arm:   "55e4cdff19f96903635c28b7521a9d504ad4406af4c99041be7506af418072fc",
         intel: "d553ccc835382f31f2167e2fae4a812489c7b8ca36758b4f650d04fba3747217"

  url "https:github.comneovideneovidereleasesdownload#{version}Neovide-#{arch}-apple-darwin.dmg"
  name "Neovide"
  desc "Neovim Client"
  homepage "https:github.comneovideneovide"

  depends_on formula: "neovim"

  app "Neovide.app"
  binary "#{appdir}Neovide.appContentsMacOSneovide"

  zap trash: [
    "~LibraryApplication Supportneovide",
    "~LibrarySaved Application Statecom.neovide.neovide.savedState",
  ]
end