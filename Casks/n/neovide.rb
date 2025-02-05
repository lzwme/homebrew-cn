cask "neovide" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.14.0"
  sha256 arm:   "d076f6d2791b984f0d1cee205722903212fca37572ed1a87be5a669c501c7b42",
         intel: "174beaa3695361e091653eb8b4a095d0e113b172f5aac9843d36ed0b06ed4826"

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