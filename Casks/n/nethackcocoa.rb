cask "nethackcocoa" do
  version "0.3.4"
  sha256 "83a9db8f633996a563fbe939141404625f9cf66180612215484f391df0475e94"

  url "https://ghfast.top/https://github.com/dirkz/NetHack-Cocoa/releases/download/v#{version}/NetHackCocoa-#{version}.dmg"
  name "NetHackCocoa"
  homepage "https://github.com/dirkz/NetHack-Cocoa"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-07-16", because: "is 32-bit only"

  app "NetHackCocoa.app"
end