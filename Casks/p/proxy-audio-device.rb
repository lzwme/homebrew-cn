cask "proxy-audio-device" do
  version "1.0.7"
  sha256 "6bdfca3e8a61f6931770de3f6813fa787891dfa8cad674f1af1f7011909c323c"

  url "https:github.combriankendallproxy-audio-devicereleasesdownloadv#{version}ProxyAudioDevice_v#{version}.zip"
  name "Proxy Audio Device"
  desc "Sound and audio controller"
  homepage "https:github.combriankendallproxy-audio-device"

  app "Proxy Audio Device Settings.app"
  artifact "ProxyAudioDevice.driver", target: "LibraryAudioPlug-InsHALProxyAudioDevice.driver"

  postflight do
    set_ownership "LibraryAudioPlug-InsHALProxyAudioDevice.driver",
                  user:  "root",
                  group: "wheel"

    system_command "binlaunchctl",
                   args:         [
                     "kickstart",
                     "-k",
                     "systemcom.apple.audio.coreaudiod",
                   ],
                   sudo:         true,
                   must_succeed: true
  end

  uninstall_postflight do
    system_command "binlaunchctl",
                   args:         [
                     "kickstart",
                     "-k",
                     "systemcom.apple.audio.coreaudiod",
                   ],
                   sudo:         true,
                   must_succeed: true
  end

  zap trash: "~LibrarySaved Application Statenet.briankendall.Proxy-Audio-Device-Settings.savedState"
end