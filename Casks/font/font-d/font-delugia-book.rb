cask "font-delugia-book" do
  version "2404.23"
  sha256 "3df81463053978e0f37bf897930cb9a6bfd64be96d06497451ca846ac6ee0bfb"

  url "https:github.comadam7delugia-codereleasesdownloadv#{version}delugia-book.zip"
  name "Delugia Code"
  homepage "https:github.comadam7delugia-code"

  font "delugia-bookDelugiaBook-Bold.ttf"
  font "delugia-bookDelugiaBook-BoldItalic.ttf"
  font "delugia-bookDelugiaBook-Italic.ttf"
  font "delugia-bookDelugiaBook.ttf"
  font "delugia-bookDelugiaBookLight-Italic.ttf"
  font "delugia-bookDelugiaBookLight.ttf"

  # No zap stanza required
end