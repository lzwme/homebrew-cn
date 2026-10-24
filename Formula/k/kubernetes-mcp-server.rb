class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://ghfast.top/https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.0.69.tar.gz"
  sha256 "621e07933333f9915a55e02abe479be61251627657ad9e8467963f783f7e1c2b"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "06414aed821e20ded62b1d0e7b6e95313963aa32566b5d9a43d39cd87bfe5588"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "18dc9b832e3863b11067f6a6ac7d9caaace0eab52166c714af7c745eb794d65c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1d1bd3abdb87182905970a9d2d35c3255a383a20c3a4c88a689ce73e6787ea49"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dcc71722884e276e79583f9fe092bf43fe2bf9a86c0e199eb85d68fadb800663"
    sha256 cellar: :any,                 x86_64_linux:      "4d421244fa8501f5eb675bf1dddb6b176a416a05dffaa219e84bdaf8c3db7d9b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/containers/kubernetes-mcp-server/pkg/version.CommitHash=#{tap.user}
      -X github.com/containers/kubernetes-mcp-server/pkg/version.BuildTime=#{time.iso8601}
      -X github.com/containers/kubernetes-mcp-server/pkg/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/kubernetes-mcp-server"
  end

  test do
    require "yaml"

    assert_match version.to_s, shell_output("#{bin}/kubernetes-mcp-server --version")

    kubeconfig = testpath/"kubeconfig"
    kubeconfig.write <<~YAML
      apiVersion: v1
      kind: Config
      clusters:
      - cluster:
          server: https://localhost:6443
          insecure-skip-tls-verify: true
        name: test-cluster
      contexts:
      - context:
          cluster: test-cluster
          user: test-user
        name: test-context
      current-context: test-context
      users:
      - name: test-user
        user:
          token: test-token
    YAML

    (testpath/"config.toml").write <<~TOML
      kubeconfig = "#{kubeconfig}"
    TOML

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"1.0"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized"}
      {"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"configuration_view","arguments":{}}}
    JSON

    output = shell_output("(echo '#{json}'; sleep 1) | #{bin}/kubernetes-mcp-server --config #{testpath}/config.toml")
    response = output.lines.map { |line| JSON.parse(line) }.find { |message| message["id"] == 2 }
    config = YAML.safe_load(response.fetch("result").fetch("content").first.fetch("text"))
    assert_equal "test-context", config["current-context"]
  end
end