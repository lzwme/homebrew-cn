cask "quarto" do
  version "1.5.56"
  sha256 "552b9edc4d72b6a09a452d0c3062f18f8d72d51487dea832732ce8b036f53d4e"

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