class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://ghproxy.com/https://github.com/onflow/cadence/archive/v0.38.0.tar.gz"
  sha256 "a4deabda542fe82c50243dbaaea2cad69673e9aabdf7fe928ef718a0262ef171"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86f94423225063ea8deb4443d324897b525bf18d294e6732c2d6bc13a8178fe5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44abd42114c00f8bab3c4e261460ed8e8ad453a8d22f83fb39cf85829c2907a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed3946898b54adc36d1e09d9acbf5b57edb93055a1f380de4ecd8a4494a8ec73"
    sha256 cellar: :any_skip_relocation, ventura:        "1fcfc1b27598b9c2f700dfb12191b4da8d3ebb82debd5cfe99f57e517f128f1e"
    sha256 cellar: :any_skip_relocation, monterey:       "712d34b1751416c40df4c18f2a43e689b42e3e09d7d405b2e0445a451c25929f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6176331ea500518531721100efe677c17e4163b500f72358a5870974e7a937f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30c2c6f57198e6a313c10997b89af322036f2e954ab09e251a43b0022dcabeb7"
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