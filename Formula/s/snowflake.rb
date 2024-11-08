class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/archive/v2.10.0/snowflake-v2.10.0.tar.gz"
  sha256 "fd0ff5fb11db8d5613d6bc00f60f3a275983f41a6d4c7d36a3b66b80e25ef5f8"
  license "BSD-3-Clause"
  head "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f926865935ace496c5465ac77b411110819c0abc381deb6e9d02dac464a4bfae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f926865935ace496c5465ac77b411110819c0abc381deb6e9d02dac464a4bfae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f926865935ace496c5465ac77b411110819c0abc381deb6e9d02dac464a4bfae"
    sha256 cellar: :any_skip_relocation, sonoma:        "342e004423b68eb1eb2fabeab0897c359c9fde404a752b8b096fe49e8d1105ce"
    sha256 cellar: :any_skip_relocation, ventura:       "342e004423b68eb1eb2fabeab0897c359c9fde404a752b8b096fe49e8d1105ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6143f4101916cb682afe11c0736fe7a11a1878d11d6ef081794046e60f37f924"
  end

  depends_on "go" => :build

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