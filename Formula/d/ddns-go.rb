class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv6.7.0.tar.gz"
  sha256 "02e850e10fef76fef41102f11fa5c606d77cab876056618d36663e1869496353"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee5453396aea3acddbe44a36932ff66b654e786dcfb96c458e1f6c5c828c8057"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee5453396aea3acddbe44a36932ff66b654e786dcfb96c458e1f6c5c828c8057"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee5453396aea3acddbe44a36932ff66b654e786dcfb96c458e1f6c5c828c8057"
    sha256 cellar: :any_skip_relocation, sonoma:         "4675d8a96732180cac901d3403c96de1f7caaca82c7534ec2a333b70a8a34b68"
    sha256 cellar: :any_skip_relocation, ventura:        "4675d8a96732180cac901d3403c96de1f7caaca82c7534ec2a333b70a8a34b68"
    sha256 cellar: :any_skip_relocation, monterey:       "4675d8a96732180cac901d3403c96de1f7caaca82c7534ec2a333b70a8a34b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dc632b82b7302d7aca927513ea249408eb71e5826b42fbf59d61bd7d914bcaa"
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