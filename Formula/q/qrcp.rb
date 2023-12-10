class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https://claudiodangelis.com/qrcp"
  url "https://ghproxy.com/https://github.com/claudiodangelis/qrcp/archive/refs/tags/0.11.0.tar.gz"
  sha256 "5e3949d99b19934dd485da2bad54ba63efeb0448aeb9616b2046398b02d57931"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d3bcb37e7c0ab1d899f4c7716d10d1badb63c74c66ba7d863e5745f3350021a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66407c0486311e25900a7b1d8fbb552e92b8feb8865eaf0966c5bd1b1ebe49d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba86e5ac0a47039551f2d5c8f32ea8596d138316e32cce07a2c5e42994cf5407"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ca6748b92fbf4f89bd76a499802250fbad82536fc559796f6a385fbcf1675ca"
    sha256 cellar: :any_skip_relocation, ventura:        "cc6f3db0705aed20f0174fb16d5027655e840104c8aed0874317f381f9f9372b"
    sha256 cellar: :any_skip_relocation, monterey:       "0fe0b9afdc569d7a9ab08c9e3b532ac9eb6d7c70cdcd4c440db8d9d29e953ad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6692f70e1d864847f364fb420eac14dab75bd0cd146abf882a67720b6055e023"
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