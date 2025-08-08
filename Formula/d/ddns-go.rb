class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghfast.top/https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.12.2.tar.gz"
  sha256 "a3ea99ad74212fc3bd1380e5ad444a1c5fe6bb1bb656624a441551034a17edaa"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8da0af2f1d523393e57186a116191b579b55d67eafeffe460d84401f3354be0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8da0af2f1d523393e57186a116191b579b55d67eafeffe460d84401f3354be0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8da0af2f1d523393e57186a116191b579b55d67eafeffe460d84401f3354be0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ee1bf6c4b24c9b92900212b3edc00552948866518098d3d49b2ad1ff68ef2b1"
    sha256 cellar: :any_skip_relocation, ventura:       "0ee1bf6c4b24c9b92900212b3edc00552948866518098d3d49b2ad1ff68ef2b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62b7bb2d7872b68a762ac9871e9cccd603d3b75facf099b9558659425a428160"
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