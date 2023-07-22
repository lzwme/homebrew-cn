class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghproxy.com/https://github.com/jeessy2/ddns-go/archive/refs/tags/v5.5.0.tar.gz"
  sha256 "2e736d5a06dc9bf5de30cc98706c89e7b447e786edf0e40b15c5353d7d064664"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd3ba3cf7871797e477fb9e345603a60c1120c7a0dec38495b2ea2b3584d0b78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd3ba3cf7871797e477fb9e345603a60c1120c7a0dec38495b2ea2b3584d0b78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd3ba3cf7871797e477fb9e345603a60c1120c7a0dec38495b2ea2b3584d0b78"
    sha256 cellar: :any_skip_relocation, ventura:        "54995f07563dadd9c73e54fadb9672da333ad870caf45c8f41da0be2d248773a"
    sha256 cellar: :any_skip_relocation, monterey:       "54995f07563dadd9c73e54fadb9672da333ad870caf45c8f41da0be2d248773a"
    sha256 cellar: :any_skip_relocation, big_sur:        "54995f07563dadd9c73e54fadb9672da333ad870caf45c8f41da0be2d248773a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28c78b69a9492890b634d4193d1a6721793229bdea84bbd3774b1f0c60be1c7a"
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