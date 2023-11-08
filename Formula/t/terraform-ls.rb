class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://ghproxy.com/https://github.com/hashicorp/terraform-ls/archive/refs/tags/v0.32.3.tar.gz"
  sha256 "1eec8a564b3d857069fc8afabe213e79edb4facb3b37b9469d7269b04c2d9d82"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13913a63a76a508c7cab13efed6c26e812d8a1b165ae064e673d68231a8513f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3dcab3d2fb9703179cda5728545581d42eeae65fa519fb4ecf1d987a955c7f19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d80768f6418b7ba6286b24f0dc5993aa93c5183f4c38a43d0b79db7741c8937"
    sha256 cellar: :any_skip_relocation, sonoma:         "e97ae69b94112e9ce7f0ad6d6cbdeba625f8f0e17f598cc8ed217ea3ca80df65"
    sha256 cellar: :any_skip_relocation, ventura:        "76300e9c4854caadd2a3594e240bd37e7132f24fa88e6a3c2e3269ed541647df"
    sha256 cellar: :any_skip_relocation, monterey:       "55ed6589975d646293d6ad75869f716bf77a9020f6fc502b5e6aa606675445ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e94a8df4e738c628da68e830f40ed1aa2434a219eb49d7b8c205fc9af0841e8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.rawVersion=#{version}+#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
  end

  test do
    port = free_port

    pid = fork do
      exec "#{bin}/terraform-ls serve -port #{port} /dev/null"
    end
    sleep 2

    begin
      tcp_socket = TCPSocket.new("localhost", port)
      tcp_socket.puts <<~EOF
        Content-Length: 59

        {"jsonrpc":"2.0","method":"initialize","params":{},"id":1}
      EOF
      assert_match "Content-Type", tcp_socket.gets("\n")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end