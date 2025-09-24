class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "6a50a20859b0f1d84e6f37705a6407dd1159dddd285abde07af9ac4cf1ab0e70"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "584e7a84fbb8fdcaab63d88b9358eaf4ec5c77b066e436fcb28349671b7cae2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "584e7a84fbb8fdcaab63d88b9358eaf4ec5c77b066e436fcb28349671b7cae2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "584e7a84fbb8fdcaab63d88b9358eaf4ec5c77b066e436fcb28349671b7cae2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f5fa9ee0696c8b007a67a41491baa85b89c3931519d1c4c070c2f9643d1068d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ff81219447702b5bcef7d7b4ec6e72399c038cc02cdfed33bca1d457eaee701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e11b7bc0be1baf6a9f52d44ad768b44ade57f2cc138bcfb74fb40fa0c218931f"
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