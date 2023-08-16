class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghproxy.com/https://github.com/jeessy2/ddns-go/archive/refs/tags/v5.6.0.tar.gz"
  sha256 "654b7428e4f9015beb6d35efab13e244ccc920dfa0752a5ab51583c118271fe6"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b97a2ff27a18cf2a215b39c8babc6fd2f51aa2d16b3be8dd64f1744a62f2af82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b97a2ff27a18cf2a215b39c8babc6fd2f51aa2d16b3be8dd64f1744a62f2af82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b97a2ff27a18cf2a215b39c8babc6fd2f51aa2d16b3be8dd64f1744a62f2af82"
    sha256 cellar: :any_skip_relocation, ventura:        "14cfbf7f313294d7510afb71edeff9aaa256b726d5da0436e98f7125f5d59193"
    sha256 cellar: :any_skip_relocation, monterey:       "14cfbf7f313294d7510afb71edeff9aaa256b726d5da0436e98f7125f5d59193"
    sha256 cellar: :any_skip_relocation, big_sur:        "14cfbf7f313294d7510afb71edeff9aaa256b726d5da0436e98f7125f5d59193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80932b94824edb78737b325eabb311f400060db8670d8ee68bafc62c9f9fe59a"
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