cask "quarto" do
  version "1.5.55"
  sha256 "83e16b21b39e5fd9036f347843b8c7e279fa5c25ef4b8da4240ea5ba08fb4841"

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