class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://ghfast.top/https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "be4c779101b23c0ba373f89eaf15b791acb692ccbcd913c74a9653e583382002"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7a76a392cbf19febc235436bd7c38b311a4709e7cc8d5a44fb8328c1396b971"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7a76a392cbf19febc235436bd7c38b311a4709e7cc8d5a44fb8328c1396b971"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7a76a392cbf19febc235436bd7c38b311a4709e7cc8d5a44fb8328c1396b971"
    sha256 cellar: :any_skip_relocation, sonoma:        "93ac1ef03b6010c6c90302251bf7e3e1529eeb62f0c5eab2aecdb5f927ff1c0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "498116f25ed64232430987c330d9256f819219a07bd6b28589dda1eaa8277e4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5026749d97630b25f719d84b2d26d9dbdf629fc7444abe204ab8b19b57ad8d92"
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