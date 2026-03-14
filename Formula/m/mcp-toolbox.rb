class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://ghfast.top/https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "6e899b949415dd566c37549f980a742f8cf626aa1b5c3ea7d5820abcf480656d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "913831c94ab203874f0184860f0c1aa85da4fb65efda9b80478c67741fb62af7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d52a8ef3732d6c8f0088a4939a71aca0f5b8223b364e1ba9b1baf8f5dd8c60e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6503254b3400588d0dce103a6348ce377feb645355fa59f827c3a31b73d1e47f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9297830551a9bf949d32c0e2cbc00ee6314d3a8caf2d8e01e5ee00b798ad6bd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acacf5a0d7040a2a449e1affb3b772537fc499baf4cb456c70d24fbd6927d0aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "474d4ec1104180566a6bdff403a7c5c5a3980642e86fcecd39bc577b82b92950"
  end

  depends_on "go" => :build

  conflicts_with "kahip", because: "both install `toolbox` binaries"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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