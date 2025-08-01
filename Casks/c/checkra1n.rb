cask "checkra1n" do
  version "0.12.4"
  sha256 "754bb6ec4747b2e700f01307315da8c9c32c8b5816d0fe1e91d1bdfc298fe07b"

  url "https://checkra.in/assets/downloads/macos/#{sha256}/checkra1n%20beta%20#{version}.dmg"
  name "checkra1n"
  desc "Jailbreak for iPhone 5s through iPhone X, iOS 12.0 and up"
  homepage "https://checkra.in/"

  livecheck do
    url :homepage
    regex(%r{href=.*?/checkra1n%20beta%20(\d+(?:\.\d+)+)\.dmg}i)
  end

  no_autobump! because: :requires_manual_review

  app "checkra1n.app"
  binary "#{appdir}/checkra1n.app/Contents/MacOS/checkra1n"

  # No zap stanza required

  caveats do
    requires_rosetta
  end
end