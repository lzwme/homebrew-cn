cask "blackhole-2ch" do
  version "0.6.0"
  sha256 "8d2223cc1aa976b70d14ff7c469cc62a64c3192177c8c0eb38df0483db790c7b"

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

  pkg "BlackHole2ch-#{version}.pkg"

  uninstall_postflight do
    system_command "usrbinkillall",
                   args:         ["coreaudiod"],
                   sudo:         true,
                   must_succeed: true
  end

  uninstall quit:    "com.apple.audio.AudioMIDISetup",
            pkgutil: "audio.existential.BlackHole2ch"

  # No zap stanza required
end