class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v1.2.4",
      revision: "c93d6af7c4b92b221707d5699e0c0dad82f93022"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "107120a7160836d4154e55660de0b669c2015070c41312b6004ab8c1444fd5f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ddc647b6e16bc7a7149c636535a1d534d8fc79e8f19e90bc78bd51b2b9ddda4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8aa319dfc0b1efab783efdb15539774c8824dad3e8c5099dfeb2e9c04d59204"
    sha256 cellar: :any_skip_relocation, sonoma:         "46d314d5091f8b3cddf62ca967f5dcae1f9fb28897ce6180393994165044625d"
    sha256 cellar: :any_skip_relocation, ventura:        "ea80c0f67abdabd0ed917d12a22f5efab0a472af0006e34794047887fac92d46"
    sha256 cellar: :any_skip_relocation, monterey:       "0ea06b6c86c23fe23de8576d3a394acee529e6c619192dc625bd5b3290c181b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3ae590a812773a4404ad0ccb5c1209b8b691469fdbc0792d7a0c920d4b7bc9f"
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