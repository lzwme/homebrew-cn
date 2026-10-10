class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.19.3.tar.gz"
  sha256 "17acfbe2cf7ea4c067ff010928e41e79a46c8f244596eea82deba99dad023e05"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "92cf78d4330b519ab92a5fa5c5129d34231925d755aa45889627cfc56c2bb4f6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "92cf78d4330b519ab92a5fa5c5129d34231925d755aa45889627cfc56c2bb4f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "92cf78d4330b519ab92a5fa5c5129d34231925d755aa45889627cfc56c2bb4f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f625532d45886642ab031d91324e5e171ecff7c3f0072344b205ada1d444039d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "19f0f0e12f743e8bc522490918babc779c38ea976c2b628156c727b636ef19ef"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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