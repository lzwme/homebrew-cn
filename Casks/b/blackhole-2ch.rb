cask "blackhole-2ch" do
  version "0.6.1"
  sha256 "c829afa041a9f6e1b369c01953c8f079740dd1f02421109855829edc0d3c1988"

  url "https:existential.audiodownloadsBlackHole2ch-#{version}.pkg"
  name "BlackHole 2ch"
  desc "Virtual Audio Driver"
  homepage "https:existential.audioblackhole"

  # The upstream website doesn't provide version information. We check GitHub
  # releases as a best guess of when a new version is released.
  livecheck do
    url "https:github.comExistentialAudioBlackHole"
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  pkg "BlackHole2ch-#{version}.pkg"

  uninstall quit:    "com.apple.audio.AudioMIDISetup",
            pkgutil: "audio.existential.BlackHole2ch"

  # No zap stanza required

  caveats do
    reboot
  end
end