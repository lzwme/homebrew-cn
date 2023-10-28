class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghproxy.com/https://github.com/jeessy2/ddns-go/archive/refs/tags/v5.6.4.tar.gz"
  sha256 "00892c90cdbbd8dd1f8f9add76857924c8e0fa5f87e727249f304d18543a8b45"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d4f546507073a56efe6b25c40d785f44bedf51d52ccc3bfe652eff65f8870a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c0dcac2d84ab4a5ef7d41938b340d8668e4aa4c52cfd74fdd6a2323247f6dcc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a1eae91ed1265b5ce7fa9756d646dfd89d3b673d985085abfdd3bc78682f761"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab6a8f80f3a066a27302c41ce2654fd402f85fc4d52525d7af3f4e3b978150cb"
    sha256 cellar: :any_skip_relocation, ventura:        "f37e370366a0f4366538069e71b2c1477d5b548063b7cf8107af5a068adae72c"
    sha256 cellar: :any_skip_relocation, monterey:       "024bfaaa84d51f8bf22601c6a4bd1b6b5dc0be18d7018e9147bfa7c264f661f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0ea962775097fff56f34c8593895d9fb9ba424d5ec998719fa3f3a09c0958b4"
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