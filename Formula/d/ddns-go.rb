class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghfast.top/https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.17.2.tar.gz"
  sha256 "dcf9b5795c6e546c2d7d9fa0cccdb57589440273ee606dac8a0bbc8f6be54afb"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7135b81e02ab34f6226b58ebb24b702d675b56a787241f23c89c1e97c6cd960a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7135b81e02ab34f6226b58ebb24b702d675b56a787241f23c89c1e97c6cd960a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7135b81e02ab34f6226b58ebb24b702d675b56a787241f23c89c1e97c6cd960a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1b705b2618fadf729e9471f203b5f3074c472129fa70bf168e616cc3f304c4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c9944e2c57d302a4c0cc6db63262e00395b21eac26b201363426ddf0c9f26a2"
    sha256 cellar: :any,                 x86_64_linux:  "b403c60ca8455d96b27a516779ef2bb7d360971d52f0c91c70444b561367f86d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ddns-go -v")

    port = free_port
    spawn "#{bin}/ddns-go -l :#{port} -c #{testpath}/ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}/clearLog"
    output = shell_output("curl --silent localhost:#{port}/logs")
    assert_match "Temporary Redirect", output
  end
end