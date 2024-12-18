class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.02.01.tar.gz"
  sha256 "095b5f0a1a7016dc884da5bb649ff36f1332338a56b23b20c1aaa74966222f5f"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "3b7b78b22bb1bf6bce803bc12857417aabe8bae4d65e31dbb911ffe8768e54d4"
    sha256 arm64_sonoma:  "4f795f4f12c94e82b9507c50f834e1ccc312ab8daf069bbc71e19695aadfd2ed"
    sha256 arm64_ventura: "601e10bce62e0b762380cca7fe9d1f356d40eb771918971dfae74902e34e1063"
    sha256 sonoma:        "296ac07fefb69a73ba8d9df76a355039146c81fa457b9949fd1562d9b9eab58f"
    sha256 ventura:       "7c93f37fbe0c5d9370b0fbb9a8e77cbd7ef1e3947915a128e6b33c7ad9083fca"
    sha256 x86_64_linux:  "e5842d93e946d980ae4ea74ca05409116ff750285c0f204d157d776a0087bebe"
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"reminders").write "ONCE 2015-01-01 Homebrew Test"
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n",
      shell_output("#{bin}/remind reminders 2015-01-01")
  end
end