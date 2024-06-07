class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.00.00.tar.gz"
  sha256 "2c5c413b89c287962b19ce34274ea62e278f05fdfcff908661851bc6f8bfab89"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "cdca1ef88d36a329b77e706f41acfcf2e304e99fb45c40a9c35b3000aec2e0ff"
    sha256 arm64_ventura:  "c72a4d747f51f1ae7e1b596ebe586f902e2bb3d3e949b725e02d24f211d86608"
    sha256 arm64_monterey: "d321592a6c705517081620fdb710da2c965317c10a30aa7e806805dba20a2714"
    sha256 sonoma:         "23ed434d3c65cad1ac0472a94f7f055507be4c9d333feeb1ca182f650b03fc64"
    sha256 ventura:        "07556aefa178aa4fd9a95a667eb518b780f8b73c2c3c7241f5f8afd85e6acba0"
    sha256 monterey:       "285f55d6bfc6266039bf691745c42f59466295909bdbd3d1f9144f2e0c1a004e"
    sha256 x86_64_linux:   "2b78e4a4274ec4dee1ab23893e13367369fda02c63c00cddc84b1d8ff302050b"
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"reminders").write "ONCE 2015-01-01 Homebrew Test"
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n",
      shell_output("#{bin}/remind reminders 2015-01-01")
  end
end