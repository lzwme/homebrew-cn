class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://ghfast.top/https://github.com/googleapis/genai-toolbox/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "90fec5a10c797ce8a9ea04d453f6fdad0d64315ea55a34521a187d10cccdfa87"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdf2295e1780c2fb52cf589e8c969513548c5098884f95d5636888e391e77bc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdf2295e1780c2fb52cf589e8c969513548c5098884f95d5636888e391e77bc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdf2295e1780c2fb52cf589e8c969513548c5098884f95d5636888e391e77bc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "102d392d1c06e3e25a15a0480f14ea50452db218f473813ab5c4bd63595ac33f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1ec8cda606ae52304ac50e032c369c62ab777521e0e678ae88b0e375861f013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9adb38654660fb76923462775e21f61c27df1c92698d81aa44dbbb3a209f389"
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