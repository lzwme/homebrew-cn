class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghfast.top/https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.16.9.tar.gz"
  sha256 "1a961050870e5a706c124de498ab84510f19ea49d9284b890a64860e1570ead2"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fafaaa0d95c618d914c01600e05caab0222dcad3fb07d778fa977c33debf56a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fafaaa0d95c618d914c01600e05caab0222dcad3fb07d778fa977c33debf56a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fafaaa0d95c618d914c01600e05caab0222dcad3fb07d778fa977c33debf56a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1eaa1268d9d525eaee731a57578384e33deae926e2501258630e018eadd33b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c36d5fbe8d3a448580b25622758da8fc6c7ad527fdc00521ff0996a9e58e579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "123562450eda6460f1d86508d4df9a8e87fde41fe8f3c24d0e0dd00bdd503a3f"
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