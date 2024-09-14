class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.00.05.tar.gz"
  sha256 "7f3590935641e8bf51b5721f1d7d6e8b909755562f4e57ec0aec7f40b3a38079"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia:  "daa2eb3d762fc4c03d36d82605b0e13f06d559fb5ab2fe3004feee3685e55348"
    sha256 arm64_sonoma:   "8e0d7d21ad3cbe5015389daad463bd8f3d2dfb8931f2bb97b4763de3b7b6f9cb"
    sha256 arm64_ventura:  "2bfeae8953e8e8e13d1ac6e02b4925e186591dce2cddfcd7c4a1246ee8063863"
    sha256 arm64_monterey: "858138b7a522fbbc9bb7773b2b1d2ed9b713656fc8c950cc55e8582d6b96ddd9"
    sha256 sonoma:         "2835250af0ee3ad47fbf47ab130b5a528d05a7b20f19525cc69db500436d31f5"
    sha256 ventura:        "8dc334f31db0b983d94d14d947478a9b4d4abba61438a464899e35c79bd38dc0"
    sha256 monterey:       "6400a2b593134832f2bd3221611afdb49ba26b98a23d3e7d37fc3b4786efffb8"
    sha256 x86_64_linux:   "c653c704958eac6457d004e3333e39acdddc0edc3f7fe1c05ab5ff51d926da31"
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