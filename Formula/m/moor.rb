class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "e2282fc61ecd50fc662e900dab17713fac57498bd21bfbb5e62d7e228297ecd9"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d86130042d47f5b4c0eb843b4c74c7de717375c332ed7335538cb3373eb144b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d86130042d47f5b4c0eb843b4c74c7de717375c332ed7335538cb3373eb144b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d86130042d47f5b4c0eb843b4c74c7de717375c332ed7335538cb3373eb144b"
    sha256 cellar: :any_skip_relocation, sonoma:        "45682912d9fad0082005eb67cb5363c14e469f1e5c48000b428914256fa315f0"
    sha256 cellar: :any_skip_relocation, ventura:       "45682912d9fad0082005eb67cb5363c14e469f1e5c48000b428914256fa315f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4ce145a061b1719e45fd3cdc3406f5acbaf8bb578f1772cf0a30155defa8745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b692935e43fc0d7c1f3592db024a7b99d3546c528ff57914a153d1e706fd5caf"
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