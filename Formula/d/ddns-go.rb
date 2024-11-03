class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv6.7.5.tar.gz"
  sha256 "b6f5f74c544c4765ac5499c3f47ec3c07e6f6a55c1ff4e510433334786cf8aaa"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00f989e75c9df72696d1de04f6469d5af64ace5cb5c8a9ee89cc9934f8a58038"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00f989e75c9df72696d1de04f6469d5af64ace5cb5c8a9ee89cc9934f8a58038"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00f989e75c9df72696d1de04f6469d5af64ace5cb5c8a9ee89cc9934f8a58038"
    sha256 cellar: :any_skip_relocation, sonoma:        "32f38f9ecc9f360c8e93c89bbdd1dc30e7a4f6704cdf3fe0a6b3c63673498d8a"
    sha256 cellar: :any_skip_relocation, ventura:       "32f38f9ecc9f360c8e93c89bbdd1dc30e7a4f6704cdf3fe0a6b3c63673498d8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c21f0d6c93228d04a1fb6e3b0600261f2fef3034c639bd2494262dba95fc9a1f"
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