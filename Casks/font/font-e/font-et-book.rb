cask "font-et-book" do
  version :latest
  sha256 :no_check

  url "https:github.comedwardtufteet-bookarchiverefsheadsgh-pages.tar.gz",
      verified: "github.comedwardtufteet-book"
  name "ET Book"
  name "Edward Tufte Book"
  homepage "https:edwardtufte.github.ioet-book"

  font "et-book-gh-pageset-booket-book-bold-line-figureset-book-bold-line-figures.ttf"
  font "et-book-gh-pageset-booket-book-display-italic-old-style-figureset-book-display-italic-old-style-figures.ttf"
  font "et-book-gh-pageset-booket-book-roman-line-figureset-book-roman-line-figures.ttf"
  font "et-book-gh-pageset-booket-book-roman-old-style-figureset-book-roman-old-style-figures.ttf"
  font "et-book-gh-pageset-booket-book-semi-bold-old-style-figureset-book-semi-bold-old-style-figures.ttf"

  # No zap stanza required
end