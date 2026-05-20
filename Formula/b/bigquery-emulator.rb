class BigqueryEmulator < Formula
  desc "Emulate a GCP BigQuery server on your local machine"
  homepage "https://github.com/goccy/bigquery-emulator"
  url "https://ghfast.top/https://github.com/goccy/bigquery-emulator/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "70e3208816ed421c090522dcef3a6122558af77e1954a2e54061235ea9751575"
  license "MIT"
  head "https://github.com/goccy/bigquery-emulator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a0aa96a7a3914cee54d279dcb92b6b8c74c6a70732da77e98e2c8232dbe87dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a0aa96a7a3914cee54d279dcb92b6b8c74c6a70732da77e98e2c8232dbe87dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a0aa96a7a3914cee54d279dcb92b6b8c74c6a70732da77e98e2c8232dbe87dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e5832b4732b51697969e522c845e79d3b8ad77eedb8a880755cbe29a054260f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8502c0a32b03e50b1e8163459422ddbd724065661feea4a186638a3c4513ecd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45a775f9ac967947ed211b4ee2c5747340f05c28f9b78959416a88687b197a43"
  end

  depends_on "go" => :build

  uses_from_macos "llvm" => :build

  fails_with :gcc

  def install
    ENV["CGO_ENABLED"] = "0"

    # Workaround to avoid patchelf corruption when cgo is required (for go-zetasql)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = "-s -w -X main.version=#{version} -X main.revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bigquery-emulator"
  end

  test do
    # https://github.com/goccy/bigquery-emulator/blob/main/_examples/python/data.yaml
    (testpath/"data.yaml").write <<~YAML
      projects:
      - id: test
        datasets:
          - id: dataset1
            tables:
              - id: table_a
                columns:
                  - name: id
                    type: INTEGER
                  - name: name
                    type: STRING
                  - name: createdAt
                    type: TIMESTAMP
                data:
                  - id: 1
                    name: alice
                    createdAt: "2022-10-21T00:00:00"
                  - id: 2
                    name: bob
                    createdAt: "2022-10-21T00:00:00"
    YAML

    port = free_port
    grpc_port = free_port
    pid = spawn bin/"bigquery-emulator", "--project=test",
                                         "--data-from-yaml=./data.yaml",
                                         "--port=#{port}",
                                         "--grpc-port=#{grpc_port}"
    sleep 10
    sleep 10 if OS.mac? && Hardware::CPU.intel?

    query = '{"query": "SELECT name FROM dataset1.table_a WHERE id = 2"}'
    query_url = "http://localhost:#{port}/bigquery/v2/projects/test/queries"
    response = JSON.parse(shell_output("curl -s -X POST -d '#{query}' #{query_url}"))
    assert_equal [{ "f" => [{ "v" => "bob" }] }], response["rows"]

    assert_match "version: #{version} (Homebrew)", shell_output("#{bin}/bigquery-emulator --version")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end