class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/mcp-toolbox"
  url "https://ghfast.top/https://github.com/googleapis/mcp-toolbox/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "4540261dfc0151a9dcac52ab96886bccdd873e3c6265d7016aa2fa9e01d8b43a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "957c10c2adbcc646d5eb6961f0e3a31351f7d384867accb1e7cb49e1b4493f78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85a1e7d917961b457e2d7eb1480675d788e0a0a90c5a94ef622277bcbd7434cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "789b6cc459813a4fddb31afcb167546c0b13a981359cf3acb29d8a013aa978bd"
    sha256 cellar: :any,                 arm64_linux:   "7170c1dab82dfa8806dd768786e8757e27c489d3037ad983872c21d354b49826"
    sha256 cellar: :any,                 x86_64_linux:  "921994701fc76289b4a6047c782f1f27b341af835434fe4224ffdbdb69e82df4"
  end

  depends_on "go" => :build

  conflicts_with "kahip", because: "both install `toolbox` binaries"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[-X github.com/googleapis/genai-toolbox/cmd.buildType=#{tap.user}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"toolbox")
    generate_completions_from_executable(bin/"toolbox", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toolbox --version")

    (testpath/"tools.yaml").write <<~YAML
      sources:
        my-sqlite-memory-db:
          kind: "sqlite"
          database: ":memory:"
    YAML

    port = free_port
    pid = spawn bin/"toolbox", "--tools-file", testpath/"tools.yaml", "--port", port.to_s

    begin
      sleep 5
      output = shell_output("curl -s -i http://localhost:#{port} 2>&1")
      assert_match "HTTP/1.1 200 OK", output, "Expected HTTP/1.1 200 OK response"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end