class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghproxy.com/https://github.com/jeessy2/ddns-go/archive/refs/tags/v5.3.1.tar.gz"
  sha256 "afca100b1b2d2b5bdcb0f6d061709136a567978e9cca85b9c0867d9219ead3f5"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47cfd7718d63616111ad8ad5f20705381d0582f9f3bfce52140dce85662ad2c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47cfd7718d63616111ad8ad5f20705381d0582f9f3bfce52140dce85662ad2c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47cfd7718d63616111ad8ad5f20705381d0582f9f3bfce52140dce85662ad2c1"
    sha256 cellar: :any_skip_relocation, ventura:        "3e250a8f17ca4604897026ee3e8ffdfb0911648c6e4fed1f9c1fb2a50ad27d15"
    sha256 cellar: :any_skip_relocation, monterey:       "3e250a8f17ca4604897026ee3e8ffdfb0911648c6e4fed1f9c1fb2a50ad27d15"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e250a8f17ca4604897026ee3e8ffdfb0911648c6e4fed1f9c1fb2a50ad27d15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ddf963d321c14120e18ac110bb9c18f64909ca7f75b37693ac9454f554c7de8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    port = free_port
    spawn "#{bin}/ddns-go -l :#{port} -c #{testpath}/ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}/clearLog"
    output = shell_output("curl --silent localhost:#{port}/logs")
    assert_equal "[]", output
  end
end