class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://ghfast.top/https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "a255befb094067fd652fec7105915e4e392d8a6546f4cd02e2c70777391c80ca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38eac076e009013fa2bc80d491ac250adfa072e95c0ac438013a79211f2a2081"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38eac076e009013fa2bc80d491ac250adfa072e95c0ac438013a79211f2a2081"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38eac076e009013fa2bc80d491ac250adfa072e95c0ac438013a79211f2a2081"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b0088284eed89f5e8f6dda954df5522c6f78a955472cf706e8872c815ac8937"
    sha256 cellar: :any_skip_relocation, ventura:       "6b0088284eed89f5e8f6dda954df5522c6f78a955472cf706e8872c815ac8937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1051d1b4f5b7bf0d79b2b51eb48198541b862f1713a56b8fa19972bc76c6f3ef"
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