cask "not-pacman" do
  version "1004"
  sha256 "4a2c4d84ad713f505a89a14eea5184e76ea5378eb08698da41afc6c4021ead13"

  url "https://stabyourself.net/dl.php?file=notpacman-#{version}/notpacman-osx.zip"
  name "Not Pacman"
  homepage "https://stabyourself.net/notpacman/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-10-15", because: :unmaintained

  app "Not Pacman.app"
end