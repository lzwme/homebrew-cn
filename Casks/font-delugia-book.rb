cask "font-delugia-book" do
  version "2111.01.2"
  sha256 "6c89156deb21d9c2c8d01a2bc19b70357d26d47a03305de5691a9a0e5e7bece0"

  url "https:github.comadam7delugia-codereleasesdownloadv#{version}delugia-book.zip"
  name "Delugia Code"
  desc "Cascadia Code + Nerd Fonts, minor difference between Caskaydia Cove Nerd Font"
  homepage "https:github.comadam7delugia-code"

  font "delugia-bookDelugiaBook-Bold.ttf"
  font "delugia-bookDelugiaBook-BoldItalic.ttf"
  font "delugia-bookDelugiaBook-Italic.ttf"
  font "delugia-bookDelugiaBook.ttf"
  font "delugia-bookDelugiaBookLight-Italic.ttf"
  font "delugia-bookDelugiaBookLight.ttf"

  # No zap stanza required
end