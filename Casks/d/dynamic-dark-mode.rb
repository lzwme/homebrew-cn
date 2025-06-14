cask "dynamic-dark-mode" do
  version "1.5.2"
  sha256 "696d5d605b3c2b54d2485936eff59cd150116f82f584b76938bf80f252d8f194"

  url "https:github.comApolloZhuDynamic-Dark-Modereleasesdownload#{version}Dynamic_Dark_Mode-#{version}.zip"
  name "Dynamic Dark Mode"
  desc "Automatic Dark Mode toggle"
  homepage "https:github.comApolloZhuDynamic-Dark-Mode"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  auto_updates true
  depends_on macos: ">= :mojave"

  app "Dynamic Dark Mode.app"

  zap trash: "~LibraryApplication Scriptsio.github.apollozhu.Dynamic.Launcher"
end