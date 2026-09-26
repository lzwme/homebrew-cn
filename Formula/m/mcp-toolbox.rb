class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/mcp-toolbox"
  url "https://ghfast.top/https://github.com/googleapis/mcp-toolbox/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "56279f3cfa9a021b37277239a29846df6bd941f5914a23f54d79aa5a47dcdcd5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d18342231bd5a5fed49d92ad0a937b47db87eb35e91be172f7f7c61e7e3b21f9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "203a02c3c2096741b3b171edaed9a63cf18415d4417f381b109bf0f4c94b5aa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8c9f4e4be485576a9153614dcdaa6987c62a949653a8b7fdfd02d7e0b3a646dc"
    sha256 cellar: :any,                 arm64_linux:       "abccc0d204d1588818f24546110fa75a8d10747aa098785b8ff567f454aaf6ad"
    sha256 cellar: :any,                 x86_64_linux:      "d7bf27ca7bcd4316dee49c2f3e3620dddf055eeca1e0c7f2ff4b4abf87b18da7"
  end

  depends_on "go" => :build

  conflicts_with "kahip", because: "both install `toolbox` binaries"

  # `test do` block binds a local port
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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