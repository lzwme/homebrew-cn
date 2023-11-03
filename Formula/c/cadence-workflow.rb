class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v1.2.5",
      revision: "eb8eea9afb3a6292ad617086d9aae0660113959f"
  license "MIT"
  head "https://github.com/uber/cadence.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50bfd5c21d2eabe8871683ff2fb9fbbdb651cc505a084165aa5d9fa2c28fd5e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dd6c84c4d23919f244eb568c1bd09035af07ee0266197ddfd649a6b1cc17b5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dd745f89204d196f142a4a571d09e226ebe6026d696fb8fb3718c87151d0cc2"
    sha256 cellar: :any_skip_relocation, sonoma:         "50f7860568228b9f10c90840e3b5b76d9f2f588e18397372428e91c2c802081f"
    sha256 cellar: :any_skip_relocation, ventura:        "69d52861f1f56d04f0a1a18a7dd9dab9e7855c279ed47da16e800250c5d252d9"
    sha256 cellar: :any_skip_relocation, monterey:       "06fcb3976b167a2e64514a03b8fef7ec5f3235cc290d3668140f6dc0ecce93b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57f233699b0387e0b401a259d2b51604fc10e2a927c0cc9b31a8137f1aa860c6"
  end

  depends_on "go" => :build

  conflicts_with "cadence", because: "both install an `cadence` executable"

  def install
    # `go` version is hardcoded in Makefile
    inreplace "Makefile" do |s|
      s.change_make_var! "EXPECTED_GO_VERSION", Formula["go"].version.to_s
    end

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
    assert_match "Loading config; env=development,zone=,configDir", output

    output = shell_output("#{bin}/cadence --domain samples-domain domain desc ", 1)
    assert_match "Error: Operation DescribeDomain failed", output
  end
end