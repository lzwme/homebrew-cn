cask "coccinellida" do
  version "0.7"
  sha256 "9eb8376fa3764e406433aff969fb5aa9f8ba78886948d013ea690cf979baaf88"

  url "https:downloads.sourceforge.netcoccinellidaCoccinellida-#{version}.zip"
  name "Coccinellida"
  desc "Simple SSH tunnel manager"
  homepage "https:coccinellida.sourceforge.net"

  livecheck do
    url "https:raw.githubusercontent.comtroydmcoccinellidamastersparkle.xml"
    strategy :sparkle
  end

  app "Coccinellida.app"
end