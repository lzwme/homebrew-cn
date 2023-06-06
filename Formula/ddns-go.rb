class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghproxy.com/https://github.com/jeessy2/ddns-go/archive/refs/tags/v5.3.2.tar.gz"
  sha256 "f04b0f373695beeb97bea760671f2c677db7d37970609ce3d95c653c33540bc3"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "048b3a718e78a062a56eb07e2758f9e1cd42cb0d903b948cffbe897069cec555"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "048b3a718e78a062a56eb07e2758f9e1cd42cb0d903b948cffbe897069cec555"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "048b3a718e78a062a56eb07e2758f9e1cd42cb0d903b948cffbe897069cec555"
    sha256 cellar: :any_skip_relocation, ventura:        "3d3be9b4f7c9da68a17b3f41b8dabf3ec361a18012ee841ae1759d153c10b925"
    sha256 cellar: :any_skip_relocation, monterey:       "3d3be9b4f7c9da68a17b3f41b8dabf3ec361a18012ee841ae1759d153c10b925"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d3be9b4f7c9da68a17b3f41b8dabf3ec361a18012ee841ae1759d153c10b925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10ff9e4f55b977251a69678e107c793a34421d67b15027434bad9d86cac2ac8c"
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