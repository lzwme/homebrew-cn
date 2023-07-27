class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghproxy.com/https://github.com/jeessy2/ddns-go/archive/refs/tags/v5.5.1.tar.gz"
  sha256 "5df02e7f1b59988719c9deabcbb2f8981e1a93a4864e535b61ec5962431732b2"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2edc6c4dfc8d5f62589267165cb2b01fa35a895b55426228b258e8f72985a2eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2edc6c4dfc8d5f62589267165cb2b01fa35a895b55426228b258e8f72985a2eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2edc6c4dfc8d5f62589267165cb2b01fa35a895b55426228b258e8f72985a2eb"
    sha256 cellar: :any_skip_relocation, ventura:        "7f468bc0ad5853c90d39793506fc5f5e81eabc3f7bac10e8f3ec4377a265eeae"
    sha256 cellar: :any_skip_relocation, monterey:       "7f468bc0ad5853c90d39793506fc5f5e81eabc3f7bac10e8f3ec4377a265eeae"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f468bc0ad5853c90d39793506fc5f5e81eabc3f7bac10e8f3ec4377a265eeae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48140aad6dafe2b6c972b9376b771cb326e687ddd6d1dd0d27a0034263e5456e"
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
    assert_match version.to_s, shell_output("#{bin}/ddns-go -v")

    port = free_port
    spawn "#{bin}/ddns-go -l :#{port} -c #{testpath}/ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}/clearLog"
    output = shell_output("curl --silent localhost:#{port}/logs")
    assert_equal "[]", output
  end
end