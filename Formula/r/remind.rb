class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.00.02.tar.gz"
  sha256 "6390e861960f68028ec7a1cf4714863620e3e95fe9e1d53e6e76698a312696e9"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "d0b728dc6115aeca34c6c14f581291ac0cfdb92c625946ce723d70d898f99e0b"
    sha256 arm64_sonoma:  "830e86f2c48e8a1667bce499636fa3da479b4a76d90dc3768a6f390aad3afbc4"
    sha256 arm64_ventura: "76ab3e339da63e8d863136a3b3f45ada0e4d9e9e376501859a0b7e9a1448e0f6"
    sha256 sonoma:        "24f9868c82eb0ea2218aa1eab2799152a88a7cf16130acd6174fbc2c993cb06a"
    sha256 ventura:       "bdb2b24100834f1298ee7386c0f17860487fa353f13ff5926daa35c0e88f96e0"
    sha256 arm64_linux:   "5133b91a3d8c8eacb51baf926db228a1935d241ce85cbda97991e894e6a17cbb"
    sha256 x86_64_linux:  "b6723a23f8dea8004ace1bd39a4bf67b1575cfe40b8020835b8a5195e1e7a3f4"
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