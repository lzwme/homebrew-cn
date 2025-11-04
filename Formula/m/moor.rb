class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "343fe0a86f085bc9e381ab2107902d98e97a158188ce0f2151d4bd0601d5ddc6"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a2a3428f0e525fbb6ed1407a1d6a2957b3033c1ee3bf2626ed181153b008391"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a2a3428f0e525fbb6ed1407a1d6a2957b3033c1ee3bf2626ed181153b008391"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a2a3428f0e525fbb6ed1407a1d6a2957b3033c1ee3bf2626ed181153b008391"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb70828fcfc1b828b9bccdea53d32f76aff21550adc41a5d9cb0c86a52871ec9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be1fd1b56a359ea26b49cb75f9b119c9abdde4b001b149e0e60bd6fd1e808a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1645570086cf51fa7d7610bc91694b8d050c900625e828e39b02c7d72282d8d7"
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