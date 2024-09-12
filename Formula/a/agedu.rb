class Agedu < Formula
  desc "Unix utility for tracking down wasted disk space"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/agedu/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-20211129.8cd63c5.tar.gz"
  version "20211129"
  sha256 "ceaee592ef21b8cbb254aa7e9c5d22cefab24535e137618a4d0af591eba8339f"
  license "MIT"
  head "https://git.tartarus.org/simon/agedu.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?agedu[._-]v?(\d+(?:\.\d+)*)(?:[._-][\da-z]+)?\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1b9c17df6a3fea5e8ca285d5de89cee23f4eb5d324da61f639bd34b57e5700bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7bd1f24bf4d884c1afbb2b3eb070983781cd9aa6b3aba84fd5920d7684e92719"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16f825c8f7835ec0b733278b2843541eb1dbcb47c3c50d225dde4be1116465ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ec8e3dfc1b9888fd099ea557c70f9618009330a7350491ee6c59629de112e16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0409e4c35d407ab4efecc0f2213821c93292d30850fab97e5f0f85646173e520"
    sha256 cellar: :any_skip_relocation, sonoma:         "38c5d351c4180941f6974ec87506cc443deb40490fdcabfdd8470753dadb0e2c"
    sha256 cellar: :any_skip_relocation, ventura:        "5c70d49574916335ab4a99f30532de28ae178703e332f0622bfd1ae380c26c4c"
    sha256 cellar: :any_skip_relocation, monterey:       "143d8821437f83555165eccb233c11b3df198b2bf80c3a228f913121450df32f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c9e044a214fcb0e6efaadc6a5361f35187baa16007be3128763683dbc637762"
    sha256 cellar: :any_skip_relocation, catalina:       "b5ac371498525743ffb8469271f513827761c91cc5bd6e3727e308867231a6c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4519cb2ca26ec7b111f6059af2e529c1f6240d97245cdef551c8564827169055"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"agedu", "-s", "."
    assert_predicate testpath/"agedu.dat", :exist?
  end
end