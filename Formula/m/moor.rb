class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "6a5b501e36edea4fed6b34f27734ba1208ba8a101cf1b78d869c940d9fa69d63"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e19a72d31c4a22cec45e706383f0b7567a49fad6dcbcad2bac899ae662de7a13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e19a72d31c4a22cec45e706383f0b7567a49fad6dcbcad2bac899ae662de7a13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e19a72d31c4a22cec45e706383f0b7567a49fad6dcbcad2bac899ae662de7a13"
    sha256 cellar: :any_skip_relocation, sonoma:        "648c64ba1ca0369efd66bfe00e558f8a3cc54c8962d3fde5bacdc6a4293a039a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "579789c0b43b48456d23c38bf1eecd7b1097939b2781003609704cbca88720e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db05348d111e18a454606f1d66b1b0e66745cb2755734eef1810cba6f0703892"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/moor"

    # Hint for moar users to start typing "moor" instead
    bin.install "scripts/moar"

    man1.install "moor.1"
  end

  test do
    # Test piping text through moor
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moor test.txt").strip
  end
end