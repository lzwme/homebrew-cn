cask "blackhole-64ch" do
  version "0.6.1"
  sha256 "8ff9606314d44ef008066732e8b18cf0dfb3c4093dfacf6fb039e6098a6e2b86"

  url "https://existential.audio/downloads/BlackHole64ch-#{version}.pkg"
  name "BlackHole 64ch"
  desc "Virtual Audio Driver"
  homepage "https://existential.audio/blackhole/"

  # The upstream website doesn't provide version information. We check GitHub
  # releases as a best guess of when a new version is released.
  livecheck do
    url "https://github.com/ExistentialAudio/BlackHole"
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  pkg "BlackHole64ch-#{version}.pkg"

  uninstall quit:    "com.apple.audio.AudioMIDISetup",
            pkgutil: "audio.existential.BlackHole64ch"

  # No zap stanza required

  caveats do
    reboot
  end
end