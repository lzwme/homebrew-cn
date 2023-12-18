cask "blackhole-64ch" do
  version "0.5.0"
  sha256 "7943397be3907e23d146ecfb6c3740220d2d35605cd23dcade65dc8bcb5da822"

  url "https:existential.audiodownloadsBlackHole64ch.v#{version}.pkg"
  name "BlackHole 64ch"
  desc "Virtual Audio Driver"
  homepage "https:existential.audioblackhole"

  # The upstream website doesn't provide version information. We check GitHub
  # releases as a best guess of when a new version is released.
  livecheck do
    url "https:github.comExistentialAudioBlackHole"
    strategy :github_latest
  end

  pkg "BlackHole64ch.v#{version}.pkg"

  uninstall_postflight do
    system_command "binlaunchctl",
                   args:         [
                     "kickstart",
                     "-kp",
                     "systemcom.apple.audio.coreaudiod",
                   ],
                   sudo:         true,
                   must_succeed: true
  end

  uninstall quit:    "com.apple.audio.AudioMIDISetup",
            pkgutil: "audio.existential.BlackHole64ch"

  # No zap stanza required
end