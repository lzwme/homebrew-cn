cask "quarto" do
  version "1.5.57"
  sha256 "97a1d0a7403c7d038a6c0a21cc3e7af964ec85a05d2ed9afbe3279eff1f1e73c"

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