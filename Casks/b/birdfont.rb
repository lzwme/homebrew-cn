cask "birdfont" do
  on_mojave :or_older do
    version "4.17.0"
    sha256 "74c778e3b7598a66b9ddb11b189ba6a21d68263fb0499a965dcedd0ac987b051"

    livecheck do
      url "https://birdfont.org/purchase.php"
      regex(%r{Mac\s*OS\s*10\.12.*?/birdfont[._-]v?(\d+(?:\.\d+)+)[._-]free\.dmg}i)
    end

    caveats do
      requires_rosetta
    end
  end
  on_catalina :or_newer do
    on_ventura :or_older do
      version "5.2.1"
      sha256 "e68b64679b8cdfbc193304edb83389e9546210ad77e886c903c30c3db89597e5"

      livecheck do
        url "https://birdfont.org/purchase.php"
        regex(%r{Mac\s*OS\s*10\.15.*?/birdfont[._-]v?(\d+(?:\.\d+)+)[._-]free\.dmg}i)
      end

      caveats do
        requires_rosetta
      end
    end
  end
  on_sonoma :or_newer do
    version "6.8.1"
    sha256 "bcd4f1c64ede96f6b1496a9ae8c88a0f7269e66698606ef3ce7d5f798593b325"

    livecheck do
      url "https://birdfont.org/purchase.php"
      regex(%r{Mac\s*OS\s*14.*?/birdfont[._-]v?(\d+(?:\.\d+)+)[._-]free\.dmg}i)
    end
  end

  url "https://birdfont.org/download/birdfont-#{version}-free.dmg"
  name "BirdFont"
  desc "Font editor"
  homepage "https://birdfont.org/"

  depends_on macos: ">= :sierra"

  app "BirdFontNonCommercial.app"

  zap trash: [
    "~/Library/Application Scripts/org.birdfont.birdfont",
    "~/Library/Containers/org.birdfont.birdfont",
  ]
end