class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://ghfast.top/https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "cce9dffdacdff7d113c23a6ca8dc375c27a231b6b14f24a677503ee22bdfc27b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79b89fa1056c6aec481a231a6117f22fee170db9491bbc250284d6e58c3689af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79b89fa1056c6aec481a231a6117f22fee170db9491bbc250284d6e58c3689af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79b89fa1056c6aec481a231a6117f22fee170db9491bbc250284d6e58c3689af"
    sha256 cellar: :any_skip_relocation, sonoma:        "0296949776ed7f68e46aca5d9fa5582da5d70f9c0d4566cbfc4d742a78e2077d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c56ff74009c5017d191ff45389e6bd3fedc077771d48911b142c46a7fddf2288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b35f5d903d4d4f4ff3b5c1c22219d5b20c87d73cfcf8eaaff919b257a0b985d"
  end

  depends_on "go" => :build

  conflicts_with "kahip", because: "both install `toolbox` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/googleapis/genai-toolbox/cmd.buildType=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"toolbox")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toolbox --version")

    (testpath/"tools.yaml").write <<~EOS
      sources:
        my-sqlite-memory-db:
          kind: "sqlite"
          database: ":memory:"
    EOS

    port = free_port
    pid = fork { exec bin/"toolbox", "--tools-file", testpath/"tools.yaml", "--port", port.to_s }

    sleep 5

    begin
      output = shell_output("curl -s -i http://localhost:#{port} 2>&1")
      assert_match "HTTP/1.1 200 OK", output, "Expected HTTP/1.1 200 OK response"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end