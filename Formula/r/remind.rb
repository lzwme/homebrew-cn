class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.02.10.tar.gz"
  sha256 "746aa587e72c32393037773fac976b6b7b29878f4eb8a728ad87f729d9a3efe6"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "449a6db7360ff7581d109b6683ceaffc32399b5fb7c5481668e319a3dde8a413"
    sha256 arm64_sequoia: "5e3c27dcf780d0398a12fb6971fd4f1cf940c608641bb8aefbccb64d7c6b97e9"
    sha256 arm64_sonoma:  "3e62639acacab04125b868e4e9972bad1502209a14e5942620b04b56e731841e"
    sha256 sonoma:        "fde37c1f81bbf8c1645a650d3741ce42ce79fbe15447936956a56e935e6bcdcb"
    sha256 arm64_linux:   "a28cdef242a380901493ec51c61199a96c789c126f071c8852cc91524ece4520"
    sha256 x86_64_linux:  "1cbdb03de8584cffee63a9be2a6a057cf804783623ab55d8ec432777b3c53348"
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