class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://ghfast.top/https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "a18dd9e173ac008f725d7111b8d70b2053dfe99049795d73a74f38ac18227b21"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "652d5e51a9f0b8691b7a7cd039f406bb7e5b9514253468bd3e6bfa7f47a0a7f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "652d5e51a9f0b8691b7a7cd039f406bb7e5b9514253468bd3e6bfa7f47a0a7f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "652d5e51a9f0b8691b7a7cd039f406bb7e5b9514253468bd3e6bfa7f47a0a7f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "66e1b40e82706e8228b1ab4e7d39109555a2be276cb04abee04fe27599b908b3"
    sha256 cellar: :any_skip_relocation, ventura:       "66e1b40e82706e8228b1ab4e7d39109555a2be276cb04abee04fe27599b908b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07d6df579fcb595e20cd7810f935d113690664c75854e346e74b73f9f2c0bd11"
  end

  depends_on "go" => :build

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