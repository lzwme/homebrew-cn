class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/archive/v2.14.0/snowflake-v2.14.0.tar.gz"
  sha256 "abdf625e24160ca748650da151ca76d6e7dbc2cca23772a3ae3b3104b255d5fa"
  license "BSD-3-Clause"
  head "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d2da64638489acce54a138cb888858dc105d12cc7517d14e737f30968a6de25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98388e4e430dc6e6197bc792351f438b958fbac411547cc241335969f6597300"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abbeed4d821f43ef5bf3fb97e1ed142a2da57a3ffb2cfcfceacfbfe4882235d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fcfa622c9ce540364bf4bf284660e3fd814209eb0065fe769fb220fa5add9d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fc40ecdf8353073ff6efe48ea944bd843fdcb7da1b2ed465a75d42d4589c2b1"
    sha256 cellar: :any,                 x86_64_linux:  "6ba8f19660fc8bdea9642fbee6c57e247c5fad3dac10ac7f1b1476d0ff5d0d18"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin/"snowflake-broker"), "./broker"
    system "go", "build", *std_go_args(ldflags:, output: bin/"snowflake-client"), "./client"
    system "go", "build", *std_go_args(ldflags:, output: bin/"snowflake-proxy"), "./proxy"
    system "go", "build", *std_go_args(ldflags:, output: bin/"snowflake-server"), "./server"

    man1.install "doc/snowflake-client.1"
    man1.install "doc/snowflake-proxy.1"
  end

  test do
    assert_match "open /usr/share/tor/geoip: no such file", shell_output("#{bin}/snowflake-broker 2>&1", 1)
    assert_match "ENV-ERROR no TOR_PT_MANAGED_TRANSPORT_VER", shell_output("#{bin}/snowflake-client 2>&1", 1)
    assert_match "the --acme-hostnames option is required", shell_output("#{bin}/snowflake-server 2>&1", 1)
  end
end