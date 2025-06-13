class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https:cadenceworkflow.io"
  url "https:github.comubercadence.git",
      tag:      "v1.3.1",
      revision: "647beb90600b232ebb6ebfb382de5ff8cf391fe2"
  license "Apache-2.0"
  head "https:github.comubercadence.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73cc5afaaf913557f5d4d6136107c0560f49b009de95d930970da4cf09656ca5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f090248bb575b58769ec64b2356153d4ab1e31ea694ed5a6ffb852648ccb0f2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cac9648fb1699432f911f3ebc10b8f23feb78861b703e5eb9b44f6166a56ad15"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ef990415df6f92dbec6209511f5ffb611e3e1b257b4fab92aff3304f41e099f"
    sha256 cellar: :any_skip_relocation, ventura:       "29ae29fa058b7db73b2e4e2951f66d5abbe3bc4f6487064860f79f850dd378d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f85c7eccb206a5baf9b724eb147d5db9ee16207f436d281ac60ab11891560ef"
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
    assert_match "no config files found within .config", output

    output = shell_output("#{bin}cadence --domain samples-domain domain desc 2>&1", 1)
    assert_match "Error: Operation DescribeDomain failed", output
  end
end