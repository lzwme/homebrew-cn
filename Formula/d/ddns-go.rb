class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghfast.top/https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.12.1.tar.gz"
  sha256 "8e6cf10808f5e89f6527f42f37e55c275f4ae17738f6836c8e9cb5e4318fff43"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b784451a2afa84074f75d2ecbe3afcc58b938d2c2f17b4311334874599e681c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b784451a2afa84074f75d2ecbe3afcc58b938d2c2f17b4311334874599e681c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b784451a2afa84074f75d2ecbe3afcc58b938d2c2f17b4311334874599e681c"
    sha256 cellar: :any_skip_relocation, sonoma:        "930e77a3a2a25c0f03d5fcbda66a6912ab57614188bdfd8c53139725e1970498"
    sha256 cellar: :any_skip_relocation, ventura:       "930e77a3a2a25c0f03d5fcbda66a6912ab57614188bdfd8c53139725e1970498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49e183e0af1f05e285e31c4e768d8bb0fd57c97a148ec63f13568bcf71382669"
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