cask "blackhole-16ch" do
  version "0.5.0"
  sha256 "573240f711010fd527698e1c63291487eee53ac1fd9e2f8ade0bf337abafcc83"

  url "https:existential.audiodownloadsBlackHole16ch.v#{version}.pkg"
  name "BlackHole 16ch"
  desc "Virtual Audio Driver"
  homepage "https:existential.audioblackhole"

  # The upstream website doesn't provide version information. We check GitHub
  # releases as a best guess of when a new version is released.
  livecheck do
    url "https:github.comExistentialAudioBlackHole"
    strategy :github_latest
  end

  pkg "BlackHole16ch.v#{version}.pkg"

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
            pkgutil: "audio.existential.BlackHole16ch"

  # No zap stanza required
end