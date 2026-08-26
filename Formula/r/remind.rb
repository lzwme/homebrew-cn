class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.03.01.tar.gz"
  sha256 "16161aba1b0494bbdac375a7fffd4a22d8e46648dc62608f4c00e731e985b7ad"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "7ce54f92097617d6979149eeece15868f25ff084fcce4af9484680cd77f64d93"
    sha256 arm64_sequoia: "1469dcd04a51f73c3682fee5a6ad7de8ec46931aacf8c2c7b05e797c183ac387"
    sha256 arm64_sonoma:  "e2314ab59f10ae06ff787d23e019057cea676223e098f339026b732595273189"
    sha256 sonoma:        "bc8ffddbb9a4c732563ce54cd54a75f75b0330313ecc83ef630667f0130c4b0f"
    sha256 arm64_linux:   "d456437652dd5fd36f13d699d236a48b6c1f60e7860256de3b6bec8713fed523"
    sha256 x86_64_linux:  "5a7c320aba4a62776268775a6ebe35692d35517034323699db1384c50a75228f"
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