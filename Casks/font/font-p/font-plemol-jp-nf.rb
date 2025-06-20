cask "font-plemol-jp-nf" do
  version "2.0.4"
  sha256 "54fe7f4d2e857f43a13914ae38638a4205913b19feb3d2f80144c510f4a6a087"

  url "https:github.comyuru7PlemolJPreleasesdownloadv#{version}PlemolJP_NF_v#{version}.zip"
  name "PlemolJP NF"
  homepage "https:github.comyuru7PlemolJP"

  no_autobump! because: :requires_manual_review

  font "PlemolJP_NF_v#{version}PlemolJPConsole_NFPlemolJPConsoleNF-Bold.ttf"
  font "PlemolJP_NF_v#{version}PlemolJPConsole_NFPlemolJPConsoleNF-BoldItalic.ttf"
  font "PlemolJP_NF_v#{version}PlemolJPConsole_NFPlemolJPConsoleNF-ExtraLight.ttf"
  font "PlemolJP_NF_v#{version}PlemolJPConsole_NFPlemolJPConsoleNF-ExtraLightItalic.ttf"
  font "PlemolJP_NF_v#{version}PlemolJPConsole_NFPlemolJPConsoleNF-Italic.ttf"
  font "PlemolJP_NF_v#{version}PlemolJPConsole_NFPlemolJPConsoleNF-Light.ttf"
  font "PlemolJP_NF_v#{version}PlemolJPConsole_NFPlemolJPConsoleNF-LightItalic.ttf"
  font "PlemolJP_NF_v#{version}PlemolJPConsole_NFPlemolJPConsoleNF-Medium.ttf"
  font "PlemolJP_NF_v#{version}PlemolJPConsole_NFPlemolJPConsoleNF-MediumItalic.ttf"
  font "PlemolJP_NF_v#{version}PlemolJPConsole_NFPlemolJPConsoleNF-Regular.ttf"
  font "PlemolJP_NF_v#{version}PlemolJPConsole_NFPlemolJPConsoleNF-SemiBold.ttf"
  font "PlemolJP_NF_v#{version}PlemolJPConsole_NFPlemolJPConsoleNF-SemiBoldItalic.ttf"
  font "PlemolJP_NF_v#{version}PlemolJPConsole_NFPlemolJPConsoleNF-Text.ttf"
  font "PlemolJP_NF_v#{version}PlemolJPConsole_NFPlemolJPConsoleNF-TextItalic.ttf"
  font "PlemolJP_NF_v#{version}PlemolJPConsole_NFPlemolJPConsoleNF-Thin.ttf"
  font "PlemolJP_NF_v#{version}PlemolJPConsole_NFPlemolJPConsoleNF-ThinItalic.ttf"
  font "PlemolJP_NF_v#{version}PlemolJP35Console_NFPlemolJP35ConsoleNF-Bold.ttf"
  font "PlemolJP_NF_v#{version}PlemolJP35Console_NFPlemolJP35ConsoleNF-BoldItalic.ttf"
  font "PlemolJP_NF_v#{version}PlemolJP35Console_NFPlemolJP35ConsoleNF-ExtraLight.ttf"
  font "PlemolJP_NF_v#{version}PlemolJP35Console_NFPlemolJP35ConsoleNF-ExtraLightItalic.ttf"
  font "PlemolJP_NF_v#{version}PlemolJP35Console_NFPlemolJP35ConsoleNF-Italic.ttf"
  font "PlemolJP_NF_v#{version}PlemolJP35Console_NFPlemolJP35ConsoleNF-Light.ttf"
  font "PlemolJP_NF_v#{version}PlemolJP35Console_NFPlemolJP35ConsoleNF-LightItalic.ttf"
  font "PlemolJP_NF_v#{version}PlemolJP35Console_NFPlemolJP35ConsoleNF-Medium.ttf"
  font "PlemolJP_NF_v#{version}PlemolJP35Console_NFPlemolJP35ConsoleNF-MediumItalic.ttf"
  font "PlemolJP_NF_v#{version}PlemolJP35Console_NFPlemolJP35ConsoleNF-Regular.ttf"
  font "PlemolJP_NF_v#{version}PlemolJP35Console_NFPlemolJP35ConsoleNF-SemiBold.ttf"
  font "PlemolJP_NF_v#{version}PlemolJP35Console_NFPlemolJP35ConsoleNF-SemiBoldItalic.ttf"
  font "PlemolJP_NF_v#{version}PlemolJP35Console_NFPlemolJP35ConsoleNF-Text.ttf"
  font "PlemolJP_NF_v#{version}PlemolJP35Console_NFPlemolJP35ConsoleNF-TextItalic.ttf"
  font "PlemolJP_NF_v#{version}PlemolJP35Console_NFPlemolJP35ConsoleNF-Thin.ttf"
  font "PlemolJP_NF_v#{version}PlemolJP35Console_NFPlemolJP35ConsoleNF-ThinItalic.ttf"

  # No zap stanza required
end