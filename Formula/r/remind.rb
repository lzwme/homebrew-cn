class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.01.04.tar.gz"
  sha256 "3d5679f62bd5ca6c8d384767fb7f2425f6574edd3b3a1530fb0837a872f6c544"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "5000511fac1fdd57b74ba01da8ad4574c15af7fd677c8c171a3cb574df2b7dc9"
    sha256 arm64_sequoia: "255488d5c6b260c0f975eb599cd56bce42be0cc9fe4cd48f41e110960330afaf"
    sha256 arm64_sonoma:  "bf3a6cde4c093c2957cfaf8a8878a52574a1f64e96a2ecf26254646850c326d0"
    sha256 sonoma:        "ed421c4a16139046f2ef10b758bb6b4bf0b96e0132d863ea300730e6827f466a"
    sha256 arm64_linux:   "aeb3ac40d4393b03058050362d5033def6b63aed889cbc1aca3fc3f4ee3b96d7"
    sha256 x86_64_linux:  "c890962a87d87f4bb4f98a7377e1901e4bdab18bcf9f7f40ca8f9fd4f2fb8078"
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