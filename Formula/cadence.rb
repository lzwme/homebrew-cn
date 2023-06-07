class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://ghproxy.com/https://github.com/onflow/cadence/archive/v0.39.2.tar.gz"
  sha256 "c41ea224d0a608e0c29e5c2888cdcc0b55938b5586c26f3b28e5ae62ccf7b73b"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c2ca90e98e95f60a4beb2b173d23784caa9674cbff6e82e70cbe5bd4dddfea1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c2ca90e98e95f60a4beb2b173d23784caa9674cbff6e82e70cbe5bd4dddfea1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c2ca90e98e95f60a4beb2b173d23784caa9674cbff6e82e70cbe5bd4dddfea1"
    sha256 cellar: :any_skip_relocation, ventura:        "a202f1367cc09d3cf4fbbb40d9d7a2e4dc447b2d197515f421b003b753e2c96b"
    sha256 cellar: :any_skip_relocation, monterey:       "a202f1367cc09d3cf4fbbb40d9d7a2e4dc447b2d197515f421b003b753e2c96b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a202f1367cc09d3cf4fbbb40d9d7a2e4dc447b2d197515f421b003b753e2c96b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51d20ed6e31303f12c6fffe46edb06dd85b09bfce5205c4beed0f9861a2060b1"
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