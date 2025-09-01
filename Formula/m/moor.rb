class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "3c09cd7a22524c77d6b7c5564688f2c8e446319eef27cbdfdcbe810a14e2ba0a"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b4752be3c9a58135fd052dce409a570a835c83f2e45f4b87e04085fe7f4a087"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b4752be3c9a58135fd052dce409a570a835c83f2e45f4b87e04085fe7f4a087"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b4752be3c9a58135fd052dce409a570a835c83f2e45f4b87e04085fe7f4a087"
    sha256 cellar: :any_skip_relocation, sonoma:        "27d65342aa46673b6ab7ba4acbe48267aca0d605b51be968e652797987c64e3c"
    sha256 cellar: :any_skip_relocation, ventura:       "27d65342aa46673b6ab7ba4acbe48267aca0d605b51be968e652797987c64e3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31c2b9def216e14ec75bb18c60a1feb32b43a325362e3f65ea7b30083ea8f8ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3960d082a198d986ab8cdf58df0d2ece9ebd39518a1cb70a83b66c207dcadd88"
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