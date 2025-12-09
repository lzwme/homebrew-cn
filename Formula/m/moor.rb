class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.9.5.tar.gz"
  sha256 "4899e65b6251871c9376814c0bebf2c2702bfbf295dcec2ecccd8e98141288a0"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b56c4b0c22d0c4327a35bc017d19a5777934ee2f7258525e5d6ecc90a65288e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b56c4b0c22d0c4327a35bc017d19a5777934ee2f7258525e5d6ecc90a65288e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b56c4b0c22d0c4327a35bc017d19a5777934ee2f7258525e5d6ecc90a65288e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cb553e71ba59be11185c4b571070504c281cea71a4a445750ef7ae024b18664"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "829f4c8f1a9d6bb37f10b5c24a5310e8588ac1f21457b8f3c1721e886c91779b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3e0632b843cb532300170c4d4609b0b70f39a4b007943a56ed51600c5001383"
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