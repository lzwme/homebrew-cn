cask "quarto" do
  version "1.6.41"
  sha256 "4fb04ea68c6be3fa31e61dfbf191ab56da5fde52f92159bc3f4fc038b1b1bc06"

  url "https:github.comquarto-devquarto-clireleasesdownloadv#{version}quarto-#{version}-macos.pkg",
      verified: "github.comquarto-devquarto-cli"
  name "quarto"
  desc "Scientific and technical publishing system built on Pandoc"
  homepage "https:www.quarto.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :el_capitan"

  pkg "quarto-#{version}-macos.pkg"

  uninstall pkgutil: "org.rstudio.quarto"

  zap trash: [
    "~LibraryApplication Supportquarto",
    "~LibraryApplication Supportquarto-writer",
    "~LibraryCachesquarto",
  ]
end