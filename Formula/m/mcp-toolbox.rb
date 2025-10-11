class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://ghfast.top/https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "779d97aaf152bc26d80315a5c31d0e1c272470e40be24d27f7f94e16a8d21e44"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73109f07c21f34bf8081a788856993641db7b49db3b4eb6466dad2c8ec1c1d8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73109f07c21f34bf8081a788856993641db7b49db3b4eb6466dad2c8ec1c1d8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73109f07c21f34bf8081a788856993641db7b49db3b4eb6466dad2c8ec1c1d8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d2ba6db546ef5d37966b7d25f39a0c63b8793e02ab60f1d9aacc3d1d99b6c5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "352029dfc895408840f0647b65b85272c9bf86d6af232abd9495ccefd60ed9ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1456fe57857a4b99957ce3d7dbbd8e80ce629723539e42bf86b83cb332fa4a3"
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