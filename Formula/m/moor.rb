class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "7d8c9c5da7e2b95cb0082ddb269da978247f5bbb62b1f2556760046b70c1051b"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b71763a6a95a3e54bc252bf7f4c53c34432000bb0f07beacc148a001d18c7fe3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b71763a6a95a3e54bc252bf7f4c53c34432000bb0f07beacc148a001d18c7fe3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b71763a6a95a3e54bc252bf7f4c53c34432000bb0f07beacc148a001d18c7fe3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c02189df15618e49660984f0ed04497b19725c221bad835205ffb820d995854"
    sha256 cellar: :any_skip_relocation, ventura:       "5c02189df15618e49660984f0ed04497b19725c221bad835205ffb820d995854"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "456820f9bf4c7698e6cad67efaf14624acd3397f5cd9c3524924f5e9a3db95f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40bcc12f943241d58e7732f6fc2d174c73f56428783c37901b89216e76b803df"
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