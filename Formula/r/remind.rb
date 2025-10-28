class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.01.08.tar.gz"
  sha256 "685d96e96721df58f1a23bf6075b8d5313a796b9c5910a056fe749b6435ce607"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "08ff06830a218cffba8757804ee5dfa5532b25d09c6ce7f51a831dfd40d51136"
    sha256 arm64_sequoia: "3750c6df7d42c58de6c6ec907fb236b167f760d92fc15ff1c51b93338dd02ad0"
    sha256 arm64_sonoma:  "1763a50f58f27181de5ea0233387e90e9c75fd92f4f61b2e49fcdea4c4d62997"
    sha256 sonoma:        "54950b9f345b6b12b9635853562cc83d8e44902b4f14bb9c3bc51ce2e8f803f6"
    sha256 arm64_linux:   "3a1d6dff941cca43d628a44137e094f1fcfe751c339b9c13d2ecb332ee260b1b"
    sha256 x86_64_linux:  "9236fa2d591d02e745539d1cbeb3796d49a2fc2bd9d4c3680d33afa5ccda30b8"
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