class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv6.10.0.tar.gz"
  sha256 "26655ad6b9d09dd75c16f588a17dab8f6927d1e56356be6a2d6d31b74bb83849"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee5a04b70ea5887cca0d59b4779d68167c2fa903e6bd25c2958f52b10ad97e12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee5a04b70ea5887cca0d59b4779d68167c2fa903e6bd25c2958f52b10ad97e12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee5a04b70ea5887cca0d59b4779d68167c2fa903e6bd25c2958f52b10ad97e12"
    sha256 cellar: :any_skip_relocation, sonoma:        "983b28f284606bd888c173d2a03a7a56b5bcbe34ea987ef02d9c61c23f5e9489"
    sha256 cellar: :any_skip_relocation, ventura:       "983b28f284606bd888c173d2a03a7a56b5bcbe34ea987ef02d9c61c23f5e9489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5eb2eecfd9be37dfa5604c51125a094a03eb6578bafa51ea5bb38a55c36732c1"
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
    assert_match version.to_s, shell_output("#{bin}ddns-go -v")

    port = free_port
    spawn "#{bin}ddns-go -l :#{port} -c #{testpath}ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}clearLog"
    output = shell_output("curl --silent localhost:#{port}logs")
    assert_match "Temporary Redirect", output
  end
end