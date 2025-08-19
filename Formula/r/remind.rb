class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.00.00.tar.gz"
  sha256 "abd4b3914838dd56a69c1f630aac9b928ed9fef013e8b95f04d43ba1f783701a"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "8260610e17155a8ece3958d3d280f5e9ec1f30c0dfa44aac23beb3abd2667164"
    sha256 arm64_sonoma:  "81ee202ae4a3ad245bf1c3fa306500f4dc307017441fa91acb0b01ebdab2f52b"
    sha256 arm64_ventura: "078ec98cd6080a45073ca36f9e8ac5e703b2f8e1b120561a8a24cde5f1c5ee4b"
    sha256 sonoma:        "abfe3280363d33a936ddef7df566da3d0dbc594045803c5e19a9977b9dcb3cfb"
    sha256 ventura:       "50ed5b638829df8cf8be2af2c369a5fa8291c198266e2639fbe98931136033ba"
    sha256 arm64_linux:   "436f54813931d8cd02fc55eb07caeda9be0f8f0292c7fc46ccbbffbbe6917a57"
    sha256 x86_64_linux:  "57742d19a5c03068e0c0caca52ff851799ecc0ca7e0a31b6078f27a3f82284b4"
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  def install
    # Fix to error: unsupported option '-ffat-lto-objects' for target 'arm64-apple-darwin24.4.0'
    inreplace "configure", "-ffat-lto-objects", "" if DevelopmentTools.clang_build_version >= 1700

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"reminders.rem").write <<~REM
      SET $OnceFile "./once.timestamp"
      REM ONCE 2015-01-01 MSG Homebrew Test
    REM
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n",
      shell_output("#{bin}/remind reminders.rem 2015-01-01")
  end
end