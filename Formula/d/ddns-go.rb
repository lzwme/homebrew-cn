class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghfast.top/https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.13.1.tar.gz"
  sha256 "3f71e243d93b19b9e08d1205a4e0868bf41cf70a18a029d1175a076ff8408169"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da73fbd2824a8d5fc984815c09ea1aefa32e76e7bab731be161cb0fa508c9266"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da73fbd2824a8d5fc984815c09ea1aefa32e76e7bab731be161cb0fa508c9266"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da73fbd2824a8d5fc984815c09ea1aefa32e76e7bab731be161cb0fa508c9266"
    sha256 cellar: :any_skip_relocation, sonoma:        "586131fe22bbb3382278f5dd9c910e1cf7fe44bca367ef5ea3374835e6938cc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bc94265f7001a9696c50220cc811a5368dda2f7efe5bf1142d97b5813a23ac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9665895e9b3945c9d1bb043221a607f33ced52b15754a55c65aaeaf563de9f6f"
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