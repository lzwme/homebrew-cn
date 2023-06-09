class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://ghproxy.com/https://github.com/onflow/cadence/archive/v0.39.5.tar.gz"
  sha256 "dc42ac48ce2b1f0c134c344b931789b62317bb3ebb3de428f8c623038b882c41"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "854e2f6d25cf136900d31618b478396219ef3fda26a27afee109811b52bed33d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "854e2f6d25cf136900d31618b478396219ef3fda26a27afee109811b52bed33d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "854e2f6d25cf136900d31618b478396219ef3fda26a27afee109811b52bed33d"
    sha256 cellar: :any_skip_relocation, ventura:        "bd9e20cdecca9a6512bb458fd2ff4ec68054c2300488265fbda5a9cbe94f476f"
    sha256 cellar: :any_skip_relocation, monterey:       "bd9e20cdecca9a6512bb458fd2ff4ec68054c2300488265fbda5a9cbe94f476f"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd9e20cdecca9a6512bb458fd2ff4ec68054c2300488265fbda5a9cbe94f476f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1c4f0feb84f0e14789e432e4442b05bc3823e1b5b46ac26f5f4411b705421b4"
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