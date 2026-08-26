class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "b6b0fddc4d3eb622af3181fa52343705387d017d59114d564cd540a11a0f3f0e"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c780ae7871183aec61d7c2ea9b20c21f792dd6fc2847b412785060cf0be151b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c780ae7871183aec61d7c2ea9b20c21f792dd6fc2847b412785060cf0be151b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c780ae7871183aec61d7c2ea9b20c21f792dd6fc2847b412785060cf0be151b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc8330118c635a89d3a08b02c4b55900d5ef676fae3958391e063a23a402a6c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5117cf428e13492a9bd478344e8bf69b81b76097c0feacb724e7bf67ae2947e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bc241d9c109d83f1d386ab8584d40765b5c8a7c7afe3c5c0d58c284765c0401"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  def install
    ldflags = "-X main.versionString=v#{version}"
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