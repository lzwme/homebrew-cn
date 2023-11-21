class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/archive/v2.8.0/snowflake-v2.8.0.tar.gz"
  sha256 "8ef5f4739bf4ff5d25c1cce3c6c4d99020e623f4677dc92b72c53bcea23c7871"
  license "BSD-3-Clause"
  head "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c7f5e37c7de14b964fe4188e2b3904dccd3ac518723ac76d003640b2961ddf4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "161e92caf07d024f686adaf0d83c20f81ab27da45ec4f052a44b70a1498741c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e2525e378bf0ce9f17fda432b3447ef38be0ac5239565a515dd83708c51af55"
    sha256 cellar: :any_skip_relocation, sonoma:         "255b742eb60ad3ef70bf537cdf77dfde9e972d5a163d9d5893fda86318f11ed7"
    sha256 cellar: :any_skip_relocation, ventura:        "1ea6f591cd6a4756df494d15c836611b74bb992b0df6697d6dd66c098b1d206e"
    sha256 cellar: :any_skip_relocation, monterey:       "b59e8a5aa4d37c15bb34625c90520e0be0b638619f8ae0d476a4154c52cda7c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45373d043e0f3728b52ce552059445d403bee1f843342bc23b2126299583a9a7"
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