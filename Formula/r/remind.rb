class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.00.04.tar.gz"
  sha256 "55ba91083f2d632f26148c21b70e4318b3c80aaf0d2f653d37850b1cabf03b7c"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "0401947164f6f16446e1854903e45bce61a45325b67b115e54b513d95c134610"
    sha256 arm64_ventura:  "d932443c5919b7b14145031c0ab4015d75c1d4fb6bcafd07c38e2c63c69e0704"
    sha256 arm64_monterey: "3e3306173c66ae3bb25b8883d0beeca25034b981689c53a3c487d5170be29821"
    sha256 sonoma:         "92eed8eec020f3d700ff93c0c1e49610e31b8e5019a17170b143f21e84605174"
    sha256 ventura:        "8eaf80c2b57177b73b15caa1be820fbf4d11cb3ff4f87bf0f642a606a17f3b76"
    sha256 monterey:       "2c1b4196a69d13a6636f16e12550a95ca99420f9b6c990212f103a7333fd480e"
    sha256 x86_64_linux:   "8c60c0fe927b9f8846316e04e2379fb178abd23a97f52306d4d56add2b91a68e"
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