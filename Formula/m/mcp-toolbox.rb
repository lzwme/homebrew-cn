class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://ghfast.top/https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "5145360ef251bb3699afb683918332a5a6790c9c41a4cd19166b130c682a13b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4111c6c7e5b6c4bb5f4a78d948ed0c3528d19a4d39ee277d3e82af87fcc63a43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faa7b3ed371973157bedcbda36b95cadf17799cb39c593dacf0f3da96ead114e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d9561092db42b68ffb4c1a27f6923c84c75ba84f8e5e817c68ba553f3395db1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff6cbd7b9577d66952c469d9f3a9215e4ee3eb04b7aa0b0dcd65bc61c1e7f204"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dafe04980da25104f97aa26dcd51ff388dba4979184ec71be588e36b55ceea5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b70378fbd7a9727747a7a05f0b7f63bfd89ab32996ec8b1bfa18965dcf4e001"
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