class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://ghfast.top/https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "868791740dcecf39204c2c106a257dc3ce2c7626fb34c1313841bc4aab9d7e56"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "889ac02be662e1d2454e25803deb37381ae030ebb4409db279a20dd55e331f19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8407686d6845f3ae4f440d51a5d9a961e0431bb782ff84451c9f3f75bbe3657"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f8837b05d7474a09dd2301f1f891b49308a56fc13bed4a60f793d81f51869f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "99b72af78ef4fd5b8684289ee25c8705073a0e199423b3dfe2c55a449e0eb50b"
    sha256 cellar: :any_skip_relocation, ventura:       "52ee51276a3f7bc7c74f040b933f6ccd626ada688d14d65d1b6f6b92238eb994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "451549a60bdb8efb982a091353f51874c6708354e466e6420df8790e624766c0"
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