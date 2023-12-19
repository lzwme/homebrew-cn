cask "luyten" do
  version "0.5.4"
  sha256 "f0d900bd9bba5dc72eb3dfe374db9bbef4222e49477a6bf18c6c14e3ddcf8eb4"

  url "https:github.comdeathmarineLuytenreleasesdownloadv#{version}_Rebuilt_with_Latest_depenenciesluyten-OSX-#{version}.zip",
      verified: "github.comdeathmarineLuyten"
  name "Luyten"
  desc "Open-source Java decompiler GUI for Procyon"
  homepage "https:deathmarine.github.ioLuyten"

  deprecate! date: "2023-12-17", because: :discontinued

  app "Luyten.app"
end