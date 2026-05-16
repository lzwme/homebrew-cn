class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.02.06.tar.gz"
  sha256 "2fc703a54b593217d5cba00bee2a8ee796030ea63bdc98592ae8c3f19352dacd"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "b67a5b6a3fbabc7c0585417f29398dd59489e558c48871b028d52e5da5344734"
    sha256 arm64_sequoia: "709b596c3ea68d4e4ba3c1cf2b551849349f4326be6e7fdab002127ab36050fd"
    sha256 arm64_sonoma:  "f3edaf643ac95953e077e670a926e0594cf88ab4c151b707e65e013f4d7b0e31"
    sha256 sonoma:        "ae4e333ce6d5ce085672d7143f52362575c1087cdda2a0ca1c47c72f33a8c63d"
    sha256 arm64_linux:   "5df87361724958a4e2ebf848d288094c7c5c9f595ebb6530ff7a4cb5eaa65117"
    sha256 x86_64_linux:  "56585de7b7ebd3baa46eb332a1004eba6f1d0d79735720b58b596d62906eee37"
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