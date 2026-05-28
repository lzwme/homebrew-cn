class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.13.3.tar.gz"
  sha256 "0e441201b119a5b31eb61fb1d2165cec83a5a2beb93f50905344ff51c3076606"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7e3d11c364d01495e078526d1f264c9af5aafffd3dbfc9c5e9872bc787d5a16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7e3d11c364d01495e078526d1f264c9af5aafffd3dbfc9c5e9872bc787d5a16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7e3d11c364d01495e078526d1f264c9af5aafffd3dbfc9c5e9872bc787d5a16"
    sha256 cellar: :any_skip_relocation, sonoma:        "639de243e0b23597ba1b181f06000c90f716bd291901de13814b7a6cca343162"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef85ba508ba04962c69d4f56e4af4562af2525bbdc0eacbebaae2ac68159c6ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07c0add8b420fd63ecd46f6c7a0fdadfede8cbcdc5fc97c4cefe31cbd1bb3939"
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