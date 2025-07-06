class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghfast.top/https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.11.2.tar.gz"
  sha256 "66d87e5109c7cf2101e9a89eed1fb23313e3c13b4cdf62cacb1b4f1625aabfd9"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8aa4d387497226937c370db0df1d6ec0beb651a1efcb7a6d951cc4ed701dba55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8aa4d387497226937c370db0df1d6ec0beb651a1efcb7a6d951cc4ed701dba55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8aa4d387497226937c370db0df1d6ec0beb651a1efcb7a6d951cc4ed701dba55"
    sha256 cellar: :any_skip_relocation, sonoma:        "38a96d08c1eb730eb97e52e40f8282c842ae10444f9896e8c442724872c87778"
    sha256 cellar: :any_skip_relocation, ventura:       "38a96d08c1eb730eb97e52e40f8282c842ae10444f9896e8c442724872c87778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "524c8a4a73849d504a9554943dbf10637902bc2c09090eab1f5c1e0070c89fc9"
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