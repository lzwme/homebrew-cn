class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://ghproxy.com/https://github.com/onflow/cadence/archive/v0.39.1.tar.gz"
  sha256 "e4b481fada85c9b98b528a8e64d17f335707fb8600fd568c0c0837b7a1c5817a"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6453aab94197580d24a9ff628188f52da258aa45a6e3e477361f40f097cc16f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6453aab94197580d24a9ff628188f52da258aa45a6e3e477361f40f097cc16f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6453aab94197580d24a9ff628188f52da258aa45a6e3e477361f40f097cc16f4"
    sha256 cellar: :any_skip_relocation, ventura:        "c8b626ee023b95678312c40e3b3e2dee31b5b88dc1a38cb172309ece28231361"
    sha256 cellar: :any_skip_relocation, monterey:       "c8b626ee023b95678312c40e3b3e2dee31b5b88dc1a38cb172309ece28231361"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8b626ee023b95678312c40e3b3e2dee31b5b88dc1a38cb172309ece28231361"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdd854f8399799da2aea048bbcafd3bbf97a0cf7ebbf4cdf086888336b7c59bf"
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