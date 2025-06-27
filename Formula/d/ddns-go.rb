class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv6.11.0.tar.gz"
  sha256 "49e2e3374911c5d0c1124dba1e6a565c2e810be9328d0b05d1cfbafb8c937958"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "268430f07049ff6e9cbe6de43f4c17f7d07990dd202a856fb2c4f355cc51bf06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "268430f07049ff6e9cbe6de43f4c17f7d07990dd202a856fb2c4f355cc51bf06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "268430f07049ff6e9cbe6de43f4c17f7d07990dd202a856fb2c4f355cc51bf06"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ef1bcb5d49bc55701bbf051e0d8857c8fa1aeb97f6c1d6e21978f0deef5b751"
    sha256 cellar: :any_skip_relocation, ventura:       "0ef1bcb5d49bc55701bbf051e0d8857c8fa1aeb97f6c1d6e21978f0deef5b751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ea09e7667f741ae02b2bcad78a32e7ca7075414c29a8cc3f9cc3a273a2915e8"
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