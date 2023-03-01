cask "font-et-book" do
  version :latest
  sha256 :no_check

  url "https://ghproxy.com/https://github.com/edwardtufte/et-book/archive/gh-pages.zip",
      verified: "github.com/edwardtufte/et-book/"
  name "ET Book"
  name "Edward Tufte Book"
  homepage "https://edwardtufte.github.io/et-book/"

  font "et-book-gh-pages/et-book/et-book-bold-line-figures/et-book-bold-line-figures.ttf"
  font "et-book-gh-pages/et-book/et-book-display-italic-old-style-figures/et-book-display-italic-old-style-figures.ttf"
  font "et-book-gh-pages/et-book/et-book-roman-line-figures/et-book-roman-line-figures.ttf"
  font "et-book-gh-pages/et-book/et-book-roman-old-style-figures/et-book-roman-old-style-figures.ttf"
  font "et-book-gh-pages/et-book/et-book-semi-bold-old-style-figures/et-book-semi-bold-old-style-figures.ttf"
end