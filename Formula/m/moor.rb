class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.9.4.tar.gz"
  sha256 "acc2ca25a7b83c2667ac544ed148cde24e405549b4d879612e39c8151382a371"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b4733fe36c7bf68b86c6b50cbb24e31068ed1e278bba652608ca662d50c4c42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b4733fe36c7bf68b86c6b50cbb24e31068ed1e278bba652608ca662d50c4c42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b4733fe36c7bf68b86c6b50cbb24e31068ed1e278bba652608ca662d50c4c42"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c33a486c5528554cc9c09ec1bf336f9462baa4e575bf837b3ccd787eeebe78b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aee7fa707b89346b0e10d9b13b85ce29fca9f577e175a3af1e59e57225a16ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70d9235bbdaf2716fcb6d0279590d879b7ea0fb82d4b2a90adc0504139ae02a7"
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