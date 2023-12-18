cask "nagstamon" do
  version "3.12.0"
  sha256 "356c701df107797ad038437406295a93d0d34ae59f8439071d182516b762c4d4"

  url "https:github.comHenriWahlNagstamonreleasesdownloadv#{version}Nagstamon.#{version}.dmg",
      verified: "github.comHenriWahlNagstamon"
  name "Nagstamon"
  desc "Nagios status monitor"
  homepage "https:nagstamon.de"

  app "Nagstamon.app"

  zap trash: "~.nagstamon"
end