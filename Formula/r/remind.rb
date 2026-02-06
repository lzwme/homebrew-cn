class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.02.03.tar.gz"
  sha256 "15af2b587793fde9dedd52656bbb3d92359a42f3acfca571fe4062cab0193f80"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "27961eeac5d9611bd0c0c7ed6c440df23cd0ee01f20ae49586db0c06456a0571"
    sha256 arm64_sequoia: "13202ba8af34e1179d3c2dfa2958e2f3ee546e12faf481b2dcf66b34320335d8"
    sha256 arm64_sonoma:  "f4db24bb7b4007192467e93ae63a33e47085b420d7fec1524f93842b8ea7ba1c"
    sha256 sonoma:        "7d21cef98025f5028245ee5b7a8b5630398b2da92ba75a45be8ef1230eda9c4b"
    sha256 arm64_linux:   "7ea3df444bc65a5e164a40a7c7b06071c9921552aca2029d9e67b2f5dfeb48e0"
    sha256 x86_64_linux:  "98515ce1ecc60c71acf68b6e55412cc90fb3054348372f877dca8e2609bb281d"
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