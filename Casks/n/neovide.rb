cask "neovide" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.13.3"
  sha256 arm:   "d17883a1ab1694c24d670986cd4f5856dfede9134cbb4904260e7e76e614dea0",
         intel: "ce540bc21760972e336b92950e32ad42d579c8db5763ce33c515f877f42ce0b4"

  url "https:github.comneovideneovidereleasesdownload#{version}Neovide-#{arch}-apple-darwin.dmg"
  name "Neovide"
  desc "Neovim Client"
  homepage "https:github.comneovideneovide"

  depends_on formula: "neovim"

  app "Neovide.app"
  binary "#{appdir}Neovide.appContentsMacOSneovide"

  zap trash: "~LibrarySaved Application Statecom.neovide.neovide"
end