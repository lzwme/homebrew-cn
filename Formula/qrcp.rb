class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https://claudiodangelis.com/qrcp"
  url "https://ghproxy.com/https://github.com/claudiodangelis/qrcp/archive/0.10.0.tar.gz"
  sha256 "70f9930cb371fa9a0a98df12442486a7802ede1a797d26fbc3363605b6574db4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89f97fa13a78fe66ca4dcc15b34f8a67ac330d31c5cc78199df3df84c967ac54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89f97fa13a78fe66ca4dcc15b34f8a67ac330d31c5cc78199df3df84c967ac54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89f97fa13a78fe66ca4dcc15b34f8a67ac330d31c5cc78199df3df84c967ac54"
    sha256 cellar: :any_skip_relocation, ventura:        "6fa91caf6178bffa47d0692eafb56dbc954982694846bbcefa78b8a776d6c6fa"
    sha256 cellar: :any_skip_relocation, monterey:       "6fa91caf6178bffa47d0692eafb56dbc954982694846bbcefa78b8a776d6c6fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fa91caf6178bffa47d0692eafb56dbc954982694846bbcefa78b8a776d6c6fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e7adf15d55d924dadb9902eb6631e1b8457c935c360dc71d698c23052c64223"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"qrcp", "completion")
  end

  test do
    (testpath/"test_data.txt").write <<~EOS
      Hello there, big world
    EOS

    port = free_port
    server_url = "http://localhost:#{port}/send/testing"

    (testpath/"config.json").write <<~EOS
      {
        "interface": "any",
        "fqdn": "localhost",
        "port": #{port}
      }
    EOS

    fork do
      exec bin/"qrcp", "-c", testpath/"config.json", "--path", "testing", testpath/"test_data.txt"
    end
    sleep 1

    # User-Agent header needed in order for curl to be able to receive file
    assert_equal shell_output("curl -H \"User-Agent: Mozilla\" #{server_url}"), "Hello there, big world\n"
  end
end