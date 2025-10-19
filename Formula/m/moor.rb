class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "19067bcb17c65ae6da8f80c3525e0859a388155025174ac65bc55d247e3b1dd4"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e84a59b6e8235b9a3933376c857aae8a38f80946a9a18e2e99f26e35c83fdf4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e84a59b6e8235b9a3933376c857aae8a38f80946a9a18e2e99f26e35c83fdf4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e84a59b6e8235b9a3933376c857aae8a38f80946a9a18e2e99f26e35c83fdf4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d27a8e409f1e32cd0fc7288d4c2d50f38d7eb2406f75d3824b90f0fb54925f88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a83ddf60d83b6a3633eed160c33f5e9d6976a317614409ba21320e86cf0f1a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "590a78d21bd3551e83a62ed3debbb4de7bb72a4fb63f1f3741188b82a0b71978"
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