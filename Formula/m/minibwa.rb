class Minibwa < Formula
  desc "Successor of BWA-MEM for short-read alignment"
  homepage "https://github.com/lh3/minibwa"
  url "https://ghfast.top/https://github.com/lh3/minibwa/archive/refs/tags/v0.6.tar.gz"
  sha256 "5a5123b85c21220492518802dc8527585a006689de2440ac4a9f4063e41fd0d2"
  license all_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d560cf8973256215118b28c14dbddf257141967a3a45a2c853c521adbbf32ef9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfd515914e9852cbce07a97b80b2b1408d76ebf4fa1dbea03f52451e7e088a93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "196405d3eaf5b623a56a0652a36e71cddedaca9bbc6605bab307efd00aa0172f"
    sha256 cellar: :any_skip_relocation, sonoma:        "46c880cd7f4e026a75d8848bbd30929670085bdf2b1866d733a99197251b860f"
    sha256 cellar: :any,                 arm64_linux:   "5f8728954f0cc0692cbf1192b5856a76860376592b6e55dc77b60ad57695fe41"
    sha256 cellar: :any,                 x86_64_linux:  "a2e79a5219d583481368fd400dfa35d142a20b35eb888b0c4e7922ed04d97042"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make", "gpl=0"

    bin.install "minibwa"
    man1.install "minibwa.1"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/.", testpath

    system bin/"minibwa", "index", "chrM-human.fa.gz", "chrM-human"
    assert_path_exists testpath/"chrM-human.l2b"
    assert_path_exists testpath/"chrM-human.mbw"

    output = shell_output("#{bin}/minibwa map chrM-human chrM-read_1.fa.gz chrM-read_2.fa.gz 2>/dev/null")
    assert_match "@SQ\tSN:chrM", output
  end
end