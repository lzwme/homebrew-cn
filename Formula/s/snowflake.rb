class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/archive/v2.15.1/snowflake-v2.15.1.tar.gz"
  sha256 "d2577fbded08bc37d9093c26c1ca142d3736137d914da11b0f55f446ba4c7a1f"
  license "BSD-3-Clause"
  head "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b0922d80bf0326d99809650c773ee2b160d59b5cdc9bedf621b1132defd22fe0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "acd4526ef6ade18a5ae01927a22d0089c8ce168a1a6b35c64fabf66a14d2d375"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1ba7794a07691e2a018bf0038990098335b4916eefa3e75e22289785578257f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3c0ed458995a3cf29f4bed33119e5fafc38f4fe5cdc19898fde121ec0a7ee497"
    sha256 cellar: :any,                 x86_64_linux:      "4cbd04f7d17c27dcad55deaa713ad735ec3f3c09d96585d41e3976a8eabf098f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"snowflake-broker"), "./broker"
    system "go", "build", *std_go_args(output: bin/"snowflake-client"), "./client"
    system "go", "build", *std_go_args(output: bin/"snowflake-proxy"), "./proxy"
    system "go", "build", *std_go_args(output: bin/"snowflake-server"), "./server"

    man1.install "doc/snowflake-client.1"
    man1.install "doc/snowflake-proxy.1"
  end

  test do
    assert_match "open /usr/share/tor/geoip: no such file", shell_output("#{bin}/snowflake-broker 2>&1", 1)
    assert_match "ENV-ERROR no TOR_PT_MANAGED_TRANSPORT_VER", shell_output("#{bin}/snowflake-client 2>&1", 1)
    assert_match "the --acme-hostnames option is required", shell_output("#{bin}/snowflake-server 2>&1", 1)
  end
end