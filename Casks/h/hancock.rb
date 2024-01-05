cask "hancock" do
  version "1.2.1"
  sha256 "1e2334f6da60b6adf9654aa340d90d7cc5d26ed6622752f127f625fe88af4232"

  url "https:github.comJeremyAgostHancockreleasesdownloadv#{version}Hancock.#{version}.dmg"
  name "Hancock"
  homepage "https:github.comJeremyAgostHancock"

  # it has been four years since the last release
  # users have reported it stopped working for m1 as well as osx
  # https:github.comJeremyAgostHancockissues8
  # https:github.comJeremyAgostHancockissues7
  # https:github.comJeremyAgostHancockissues6
  disable! date: "2024-01-01", because: :unmaintained

  app "Hancock.app"
end