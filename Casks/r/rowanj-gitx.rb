cask "rowanj-gitx" do
  version "0.15,1964"
  sha256 "d88bcb7f92ca1cdf31cb3f1d2e24c03e2091ab330319aeef2e770c0dbd6f7817"

  url "https:github.comrowanjgitxreleasesdownloadbuilds#{version.csv.first}#{version.csv.second}GitX-dev-#{version.csv.second}.dmg",
      verified: "github.comrowanjgitx"
  name "GitX-dev"
  desc "Native graphical client for the git version control system"
  homepage "https:rowanj.github.iogitx"

  disable! date: "2024-12-16", because: :discontinued

  conflicts_with cask: "gitx"

  app "GitX.app"
  binary "#{appdir}GitX.appContentsResourcesgitx"
end