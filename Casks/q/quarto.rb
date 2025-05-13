cask "quarto" do
  version "1.7.31"
  sha256 "0776712f40d4bf856fecfc6be4e09e286587932a60961dfb3b97e126683096aa"

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