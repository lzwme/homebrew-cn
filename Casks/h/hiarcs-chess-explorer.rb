cask "hiarcs-chess-explorer" do
  on_sierra :or_older do
    version "1.9.4"
    sha256 "eaf7627801ca4cc2351fef58bb313353eca2a51d894e28df2b627dd011856a7f"

    livecheck do
      skip "Legacy version"
    end
  end
  on_high_sierra do
    version "1.11.1"
    sha256 "6f188f9c9041ed5667f0398e7b2a9b00d998bd6c77e9391163895bbd746f49ee"

    livecheck do
      skip "Legacy version"
    end
  end
  on_mojave :or_newer do
    version "1.13"
    sha256 "7b34bead03bb9f90ac56f54cb5b728af146025c3271b1a07d07dbcf5ffcbeeb3"

    livecheck do
      url "https://www.hiarcs.com/mac-chess-explorer-download.html"
      regex(%r{href=.*?/HIARCS-Chess-Explorer-Installer[._-]v?(\d+(?:\.\d+)+[a-z]?)\.pkg}i)
    end
  end

  url "https://www.hiarcs.com/hce/HIARCS-Chess-Explorer-Installer-v#{version}.pkg"
  name "(Deep) HIARCS Chess Explorer"
  desc "Chess database, analysis and game playing program"
  homepage "https://www.hiarcs.com/mac-chess-explorer.html"

  no_autobump! because: :requires_manual_review

  pkg "HIARCS-Chess-Explorer-Installer-v#{version}.pkg"

  uninstall signal:  ["TERM", "com.hiarcs.chessexplorer"],
            pkgutil: "com.hiarcs.*"

  zap trash: "~/Library/Preferences/com.hiarcs.Chess Explorer.plist",
      rmdir: "~/Documents/HIARCS Chess"
end