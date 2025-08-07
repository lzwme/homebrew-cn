class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v1.3.3",
      revision: "5b5baa798a77cd13016c7f8eb9f0a87bf2243167"
  license "Apache-2.0"
  head "https://github.com/uber/cadence.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "689f1853f001c375f89c26f17b2542774819da96d9337e47661711188c75cb38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb413bfcbfd48db53a01a1f0b34632780dcf2de34c66501e8b9923a0a16df92c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f0f765437c226e1379d16ebb6af61d40af66ca728ab7c1f193db3974e7220bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "578ed85a4d1341ca6edcf5e7937e21b182d574aeaa9b73375b730233c225d407"
    sha256 cellar: :any_skip_relocation, ventura:       "9f193efcf9c1b286d90455b5960006545a8fb8c5d158ccc6085cd5cb11e49418"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8d7a779075246c8c37c1e56c4a2b8a926f3048586ece0be22fee11f5cfb0f45"
  end

  depends_on "go" => :build

  conflicts_with "cadence", because: "both install an `cadence` executable"

  def install
    system "make", ".just-build"
    make_args = %w[
      cadence
      cadence-server
      cadence-canary
      cadence-sql-tool
      cadence-cassandra-tool
    ]
    make_args << "EMULATE_X86=" unless Hardware::CPU.intel?
    system "make", *make_args

    bin.install "cadence"
    bin.install "cadence-server"
    bin.install "cadence-canary"
    bin.install "cadence-sql-tool"
    bin.install "cadence-cassandra-tool"

    (etc/"cadence").install "config", "schema"
  end

  test do
    output = shell_output("#{bin}/cadence-server start 2>&1", 1)
    assert_match "no config files found within ./config", output

    output = shell_output("#{bin}/cadence --domain samples-domain domain desc 2>&1", 1)
    assert_match "Error: Operation DescribeDomain failed", output
  end
end