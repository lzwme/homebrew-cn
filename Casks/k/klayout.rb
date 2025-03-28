cask "klayout" do
  on_catalina :or_older do
    version "0.28.12"
    sha256 "b2bca1ad625f84be8d6eeba7cc4864c83dd09d01d4e413059c8cff130c825b3e"

    url "https://www.klayout.org/downloads/MacOS/HW-klayout-#{version}-macOS-Catalina-1-qt5Brew-RsysPhb39.dmg",
        verified: "klayout.org/downloads/MacOS/"

    livecheck do
      skip "Legacy version"
    end
  end
  on_big_sur do
    version "0.28.12"
    sha256 "1c7b6e12ac722d718dfc1711dd4d05cfa0a7b97d60ad02f98cd15cbae22d7fb0"

    url "https://www.klayout.org/downloads/MacOS/HW-klayout-#{version}-macOS-BigSur-1-qt5Brew-RsysPhb39.dmg",
        verified: "klayout.org/downloads/MacOS/"

    livecheck do
      skip "Legacy version"
    end
  end
  on_monterey do
    version "0.29.6"
    sha256 "2c324dc95d77a0167d6c56608d2beca5f78b5190259480d97ef1500b19bc7389"

    url "https://www.klayout.org/downloads/MacOS/HW-klayout-#{version}-macOS-Monterey-1-qt5MP-RsysPhb311.dmg",
        verified: "klayout.org/downloads/MacOS/"

    livecheck do
      skip "Legacy version"
    end
  end
  on_ventura do
    version "0.30.0"
    sha256 "5fcac1c53245fb420d271dc236e1793ac715bba6147ca232cdd6cf87be32176d"

    url "https://www.klayout.org/downloads/MacOS/HW-klayout-#{version}-macOS-Ventura-1-qt5MP-RsysPhb311.dmg",
        verified: "klayout.org/downloads/MacOS/"

    livecheck do
      url "https://www.klayout.de/build.html"
      regex(/href=.*?HW[._-]klayout[._-](\d+(?:\.\d+)+)[._-]macOS[._-]Ventura.*?\.dmg/i)
    end
  end
  on_sonoma do
    version "0.30.0"
    sha256 "5c7adf2f76ef8ba52ad7a596d7a3cbe438539e2fa90290a1c7a051240a074d8a"

    url "https://www.klayout.org/downloads/MacOS/HW-klayout-#{version}-macOS-Sonoma-1-qt5MP-RsysPhb311.dmg",
        verified: "klayout.org/downloads/MacOS/"

    livecheck do
      url "https://www.klayout.de/build.html"
      regex(/href=.*?HW[._-]klayout[._-](\d+(?:\.\d+)+)[._-]macOS[._-]Sonoma.*?\.dmg/i)
    end
  end
  on_sequoia :or_newer do
    version "0.30.0"
    sha256 "64f82b9dc868a70ff05e8c6b0884f438eb83ba9e90814c3d1e320c554bd551fd"

    url "https://www.klayout.org/downloads/MacOS/HW-klayout-#{version}-macOS-Sequoia-1-qt5MP-RsysPhb311.dmg",
        verified: "klayout.org/downloads/MacOS/"

    livecheck do
      url "https://www.klayout.de/build.html"
      regex(/href=.*?HW[._-]klayout[._-](\d+(?:\.\d+)+)[._-]macOS[._-]Sequoia.*?\.dmg/i)
    end
  end

  name "KLayout"
  desc "IC design layout viewer and editor"
  homepage "https://www.klayout.de/"

  depends_on macos: ">= :catalina"

  suite "KLayout"

  preflight do
    # There is no sub-folder in the DMG; the root *is* the folder
    FileUtils.mv(staged_path.children, staged_path.join("KLayout").tap(&:mkpath))
  end

  uninstall quit:    "klayout.de",
            pkgutil: "klayout.de"

  zap trash: "~/.klayout"
end