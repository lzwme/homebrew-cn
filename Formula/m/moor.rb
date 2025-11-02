class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "f4fa51463b8e9f28088de017a45a06550071383fdd846ad924e7e80b2b5cb72c"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2392ecb006f3741d4363b51d78e5af10999245a4d3482eb4e9d73b73068d0207"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2392ecb006f3741d4363b51d78e5af10999245a4d3482eb4e9d73b73068d0207"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2392ecb006f3741d4363b51d78e5af10999245a4d3482eb4e9d73b73068d0207"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae730246a872234b5ee00b68e8534fc4eccfed5f1be50025bf19c4ff6a968db1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8747e70382341f1eef98420b6d484d87c04620f53ab3a92cbdf7fb337fa95c0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df5e051aa12a8815151a0a27fec8520015c4337b2f4fe75ba075677fbcb5731b"
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