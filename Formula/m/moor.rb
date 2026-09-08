class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "47a5da205f0af3711a164f579dfebc7c765b54cd9360a353df477c7370b88699"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddba716870db2e276dbdd591a12878faa0664911c1277f61dc592bc46a3e4ec5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddba716870db2e276dbdd591a12878faa0664911c1277f61dc592bc46a3e4ec5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddba716870db2e276dbdd591a12878faa0664911c1277f61dc592bc46a3e4ec5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "239a7cd4be302002ae5665e2affcd731adb41f3dd0ac15f566c774dc91570ba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49b7ccfae97c522fbff01039013ad2aa090bbdbcded189b66f63ea36ce153410"
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