class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://ghfast.top/https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "f13625783e36569b46d200446d37358d97139771bdc91cbada6fcf76b859162c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d7515c5322b2bcbf09d4cb27491b3b643a215bedd3133275661c846d97d8bb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d7515c5322b2bcbf09d4cb27491b3b643a215bedd3133275661c846d97d8bb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d7515c5322b2bcbf09d4cb27491b3b643a215bedd3133275661c846d97d8bb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ce564e6c4146045e01360a8b6ec13017680369ed5dd7ecd27becf3090e8e8f6"
    sha256 cellar: :any_skip_relocation, ventura:       "1ce564e6c4146045e01360a8b6ec13017680369ed5dd7ecd27becf3090e8e8f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e2ab2abf78106b4ae8fbd42104ff921c215216efe1299048441ca2beb80247a"
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