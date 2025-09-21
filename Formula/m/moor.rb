class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "af238559e623981907b70582cf613cfece1fa8464339de5744963b05645d6d40"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4ac385010e59699ea4ea867d9bba5dcc296de756912b1f6301228a834c99662"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4ac385010e59699ea4ea867d9bba5dcc296de756912b1f6301228a834c99662"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4ac385010e59699ea4ea867d9bba5dcc296de756912b1f6301228a834c99662"
    sha256 cellar: :any_skip_relocation, sonoma:        "258435adcd15785513a41a8965184550033b2b744bd8d82869416a3af811bb47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73ef7b1095d9ecb7536672daf564c17c315cb5faf8d53d6bc0a31fa97200c1f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6aaf8ea03ee80541065379fc0071042a4b36a533ab61e804ac36e5f67e6696d"
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