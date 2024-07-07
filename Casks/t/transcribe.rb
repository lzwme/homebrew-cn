cask "transcribe" do
  arch arm: "arm", intel: "intel"

  on_catalina :or_older do
    version "8.75.2"
    sha256 "f01781100cd3b9987c8f8892145a2eaa358df07b92e10e26f30b6a877f5b352c"

    url "https://www.seventhstring.com/xscribe/downmo/transcribe#{version.no_dots}.dmg"

    livecheck do
      skip "Legacy version"
    end

    zap trash: [
      "~/Library/Preferences/com.seventhstring.transcribe.plist",
      "~/Library/Preferences/Transcribe!#{version.major} Preferences",
    ]
  end
  on_big_sur do
    version "9.21"
    sha256 :no_check

    on_arm do
      url "https://www.seventhstring.com/xscribe/downmo/11_12/transcribe_arm.dmg"
    end
    on_intel do
      url "https://www.seventhstring.com/xscribe/downmo/11_12/transcribe.dmg"
    end

    livecheck do
      skip "Legacy version"
    end

    zap trash: [
      "~/Library/Preferences/com.seventhstring.transcribe.plist",
      "~/Library/Preferences/Transcribe!#{version.major} Preferences",
    ]
  end
  on_monterey do
    version "9.21"
    sha256 :no_check

    on_arm do
      url "https://www.seventhstring.com/xscribe/downmo/11_12/transcribe_arm.dmg"
    end
    on_intel do
      url "https://www.seventhstring.com/xscribe/downmo/11_12/transcribe.dmg"
    end

    livecheck do
      skip "Legacy version"
    end

    zap trash: [
      "~/Library/Preferences/com.seventhstring.transcribe.plist",
      "~/Library/Preferences/Transcribe!#{version.major} Preferences",
    ]
  end
  on_ventura :or_newer do
    version "9.41.2"
    sha256 arm:   "d4ab4f93bb4adce192df7bcd61edc808ebc185a5313bf0170663da90231bc0e5",
           intel: "58a7bdbd8913a5404ca883d12b6881d655cee3324a726844b39f283cd800e210"

    url "https://www.seventhstring.com/xscribe/downmo/transcribe-#{arch}-#{version}.dmg"

    livecheck do
      url "https://www.seventhstring.com/xscribe/download_mac.html"
      regex(/transcribe[._-]#{arch}[._-]v?(\d+(?:\.\d+)+)\.dmg/i)
    end

    zap trash: [
      "~/Library/Preferences/com.seventhstring.transcribe.plist",
      "~/Library/Preferences/Transcribe!#{version.major} Preferences",
    ]
  end

  name "Transcribe!"
  desc "Transcribes recorded music"
  homepage "https://www.seventhstring.com/xscribe/overview.html"

  app "Transcribe!.app"

  uninstall quit: "com.seventhstring.transcribe"
end