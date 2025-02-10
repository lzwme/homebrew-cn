class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.03.02.tar.gz"
  sha256 "1872ded82e62d055be21b299b7133695dc7e4e667ec2db41defb48cef0f06665"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "6a49b0a17738df2579ccf992281fb1b925cd6ee2787141510f9b4bcf9784c3b2"
    sha256 arm64_sonoma:  "57bb363f014ca83e964147d6f4bf07cdd3ba0a7f1549c0ba8109ce54556e8b66"
    sha256 arm64_ventura: "f32fc62470dd2117fdad1a6b43720ad9c5282f3033b29d6a5453390036acf14b"
    sha256 sonoma:        "78c44553861332f405d32309574580f997cb50728a8bd975fd76fcc1650ef48c"
    sha256 ventura:       "f0f9900c4bfde547e3f1fa0ec0ce7afe8c5e1a62a472609345786775410c8869"
    sha256 x86_64_linux:  "285ab84ebba7ff2f23b676354008eb46a6efac525385d5ee2785b99c5e2e8a95"
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