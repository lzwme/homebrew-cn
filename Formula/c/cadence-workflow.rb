class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https:cadenceworkflow.io"
  url "https:github.comubercadence.git",
      tag:      "v1.2.12",
      revision: "f3350d0da50887770d7c365dc270703ff26b4178"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3fa19acf1273dbbda378f088c8b18cfbbb7af4fb33d3a07c025f8413aa273304"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2472be6f8e45cafb9de2f92898e933d798a08458090292eda07f3f38b4c920f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a9cc7e9a0cd2b8b62d5856b30da0f8a908c7b3ce5e1a5ce433fa621b883fa3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5232107997c53fe801ddcd7646a63dfb52bb5fb8577a0878d5102b6237bd287"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa8bef8f4f8ff7e721c780417bca865500468a35d491a59cd32b0d07d849d3ad"
    sha256 cellar: :any_skip_relocation, ventura:        "6003cdd0950385cf0453cfbf5f06321255f2c526f2b2d181510d174d31fb58a7"
    sha256 cellar: :any_skip_relocation, monterey:       "0b7b24e99141d445d7a62607b7f130b5f1f3f701946a02a1d6f199c2b8743c01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "670f6605b97fa449c129aee7d6ee51ca4a7f2e8a7f8846773e5eaef585b2bda0"
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

    output = shell_output("#{bin}cadence --domain samples-domain domain desc ", 1)
    assert_match "Error: Operation DescribeDomain failed", output
  end
end