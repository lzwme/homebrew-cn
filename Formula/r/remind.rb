class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.01.06.tar.gz"
  sha256 "b3c49d0faa0b363dd5299061adf49d27112b2db4156b26c05de83559129f41e1"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "1f97fe2ea03e0db4da6ebe50f9b3b28db5519e9dc9727810c8629389fbab1564"
    sha256 arm64_sequoia: "67c78a5078ab0eb9ca776c1d70e8aff0e288bed6b8aaedb250e7eb6d841942f8"
    sha256 arm64_sonoma:  "d1a0203ae2bfc843f9c5fd848f374271ccbf687d6d7a6f3edcf7805ae490a364"
    sha256 sonoma:        "e8c2c7c66e229c10b06c317c7b175d3bf3ea32364fce2c1f56905e6b7aff779d"
    sha256 arm64_linux:   "28a0665460af5457431c4eb4360c9d02615a46680e23f63b260941ad5de4ef42"
    sha256 x86_64_linux:  "45860bcbb0b25b31c1fdb7c35df13af7b74f6519c4038fe340cd5b96762bf070"
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