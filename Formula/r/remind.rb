class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.04.00.tar.gz"
  sha256 "743fb6d95d7e0cc7127d19b16208f36ebe9b56806eaa4f33eccde8f350544777"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "60217aa962b91269620ccc107258d5bd12c4e39c5986f4eab5ca37a3d090c8ec"
    sha256 arm64_sonoma:  "0fd42c5882bd2eb77b47a52df79d1dfb90a4fd9236aa8a79b1a52310bda53be7"
    sha256 arm64_ventura: "25cbc2f1e233cf1f3f17c385d79931a38309a0359e70fdef7bb7ed67b426a855"
    sha256 sonoma:        "30c5070538906d52aeb99d6b1806d257aaf25c3873b4c3900fb0339428d41567"
    sha256 ventura:       "aca2c9ad03c50894c94897fcb35bb249d10c4553b5a6dc1211aac98878a36a27"
    sha256 arm64_linux:   "7d7a4fcf436e5f6b5d413853c525e41fd53b553d2009813e9322caf1aba30f95"
    sha256 x86_64_linux:  "7c26e44460b585154157f0b59a69031abd12a0804e1e39092971ef932cf316bc"
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