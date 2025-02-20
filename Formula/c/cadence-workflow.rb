class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https:cadenceworkflow.io"
  url "https:github.comubercadence.git",
      tag:      "v1.2.16",
      revision: "3ab9c0512d5eb574a2567c7c0c1938e1ebe85d06"
  license "MIT"
  head "https:github.comubercadence.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32efab3edbfc70bbe18968f10c2b760b9ced1fc14015ecb18c2485e796c2311c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6563628123bb4a4f36ed26064b640ae44ebd7029fc2fb7dea3bc3084b339065"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c8071953c72fec78b87825fd16ca8fff62e48a6567a4aa5ae3029f1524be3c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "dace8ae31bf500b6620f08ebf43b5a621e0d24e4c7bb387a33ea11d3727cd661"
    sha256 cellar: :any_skip_relocation, ventura:       "13518200e93236c2a29ecc478b125441ca0a0aef1fc34a819ecb143841836df2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "264bfbd8f89d8d771c599b9a0d247739a77a02545bcf9555c48927d9cc07b36b"
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

    (etc"cadence").install "config", "schema"
  end

  test do
    output = shell_output("#{bin}cadence-server start 2>&1", 1)
    assert_match "Loading config; env=development,zone=,configDir", output

    output = shell_output("#{bin}cadence --domain samples-domain domain desc 2>&1", 1)
    assert_match "Error: Operation DescribeDomain failed", output
  end
end