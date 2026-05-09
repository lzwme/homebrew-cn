class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "238717993c9cb769aea69c9847a3d01ba60d30c46fd4ddfac9b4aaea0f0431af"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40f632d6f40fadeae3f8bdaf730b8c76607a2d6ae9951071137d4e0a8ad7ab51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40f632d6f40fadeae3f8bdaf730b8c76607a2d6ae9951071137d4e0a8ad7ab51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40f632d6f40fadeae3f8bdaf730b8c76607a2d6ae9951071137d4e0a8ad7ab51"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6cff7181639004be6ad7cc3b81b97c97e6350e31f3294c1c1c3fd2d9ab09f81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6edbe1eafdeb47d258796eafdc72da220adf179e8169757dd714004f528f2c80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "280b173b67a5184f7d289255842f356e561ce31fe69a8e7e4fc4114722cb5512"
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