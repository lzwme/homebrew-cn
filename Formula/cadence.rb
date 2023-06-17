class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://ghproxy.com/https://github.com/onflow/cadence/archive/v0.39.9.tar.gz"
  sha256 "4d8858051880641cb563204b59522e39d8c0abbc3a473dd74e9f2284fcc8a849"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "679f679f093977b36c012d6652b5f350e6e3a3fb78a09a014f6c352db5ab2d62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "679f679f093977b36c012d6652b5f350e6e3a3fb78a09a014f6c352db5ab2d62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "679f679f093977b36c012d6652b5f350e6e3a3fb78a09a014f6c352db5ab2d62"
    sha256 cellar: :any_skip_relocation, ventura:        "6d1ad1cb80bab5536d9221de532ae6977f3f40dacbac6d7ecef983500ef67b1c"
    sha256 cellar: :any_skip_relocation, monterey:       "6d1ad1cb80bab5536d9221de532ae6977f3f40dacbac6d7ecef983500ef67b1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d1ad1cb80bab5536d9221de532ae6977f3f40dacbac6d7ecef983500ef67b1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c44b489bd479f62bacad91ca0e002db4bdb1887f4dfaee5f1aedf474f8f14948"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end