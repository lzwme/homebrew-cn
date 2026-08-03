class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.16.2.tar.gz"
  sha256 "20873548bbc9200bfd07b464f420ee6428d433f8a96d98c81af1b65020a84114"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d02f55695a179709453d6fed892a18d602a3f4ca1f9379457dcf438929e62f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d02f55695a179709453d6fed892a18d602a3f4ca1f9379457dcf438929e62f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d02f55695a179709453d6fed892a18d602a3f4ca1f9379457dcf438929e62f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4eae71cf0f1ad860c1a5b1672d69c0f2f7dcb867fa3866be7f82ee46620e17a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a92a88e5cdc7820516006c87b66bfeb139a2abba1e7e3217477d66ea40815cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c178c3750ccd53ab517bc48033ff2db80708bae5071353d6b4e781e29210737b"
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