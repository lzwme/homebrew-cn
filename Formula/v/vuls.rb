class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  url "https://ghfast.top/https://github.com/future-architect/vuls/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "4ac02e1831953d752b16e90900a55c571d2efe836b12797d8ffc45ad180a4d9a"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6ccb5e486ccd93c5fc8e34a1e686be63f16a5cc5f2a6d54aa0a7279d59448106"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ccb5e486ccd93c5fc8e34a1e686be63f16a5cc5f2a6d54aa0a7279d59448106"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6ccb5e486ccd93c5fc8e34a1e686be63f16a5cc5f2a6d54aa0a7279d59448106"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b08825409c3331c4faa677d8f40c0ec04eef92f9b8241e6eb7340759fbdc0ea5"
    sha256 cellar: :any,                 x86_64_linux:      "549ddf900e99934b7ae33510bb9a9502100420c4c93c1e34cb4dad1fc3bf6bad"
  end

  # TODO: unpin go@1.26 when vuls (and trivy) support go 1.27
  # ref: https://github.com/aquasecurity/trivy/pull/11127
  depends_on "go@1.26" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["GOEXPERIMENT"] = "jsonv2"

    ldflags = %W[
      -X github.com/future-architect/vuls/config.Version=#{version}
      -X github.com/future-architect/vuls/config.Revision=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"vuls"), "./cmd/vuls"
    system "go", "build", *std_go_args(ldflags:, output: bin/"vuls-scanner"), "./cmd/scanner"
    system "go", "build", *std_go_args(ldflags:, output: bin/"trivy-to-vuls"), "./contrib/trivy/cmd"
    system "go", "build", *std_go_args(ldflags:, output: bin/"future-vuls"), "./contrib/future-vuls/cmd"
    system "go", "build", *std_go_args(ldflags:, output: bin/"snmp2cpe"), "./contrib/snmp2cpe/cmd"
  end

  test do
    # https://vuls.io/docs/en/config.toml.html
    (testpath/"config.toml").write <<~TOML
      [default]
      logLevel = "info"

      [servers]
      [servers.127-0-0-1]
      host = "127.0.0.1"
    TOML

    %w[vuls vuls-scanner].each do |cmd|
      assert_match "Failed to configtest", shell_output("#{bin}/#{cmd} configtest 2>&1", 1)
    end

    %w[trivy-to-vuls future-vuls snmp2cpe].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} version")
    end
  end
end