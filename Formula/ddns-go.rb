class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghproxy.com/https://github.com/jeessy2/ddns-go/archive/refs/tags/v5.5.2.tar.gz"
  sha256 "2d8110d8ca989d872e21f6908781376af0a47f5c35a8cab00daaa0ef5526fa79"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab368a306dacc2c95d5c593e6b29720fea77acdcadbe7b67474c2b49822a751f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab368a306dacc2c95d5c593e6b29720fea77acdcadbe7b67474c2b49822a751f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab368a306dacc2c95d5c593e6b29720fea77acdcadbe7b67474c2b49822a751f"
    sha256 cellar: :any_skip_relocation, ventura:        "dcb790751af8c7518d6f8aa573a0a53c36952bff4ad25f99b183fa38c3358007"
    sha256 cellar: :any_skip_relocation, monterey:       "dcb790751af8c7518d6f8aa573a0a53c36952bff4ad25f99b183fa38c3358007"
    sha256 cellar: :any_skip_relocation, big_sur:        "dcb790751af8c7518d6f8aa573a0a53c36952bff4ad25f99b183fa38c3358007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "256a3e0e03b0c08c73d214517b470e53711cbe4a9169d1d7967ab9d7e6ae5336"
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