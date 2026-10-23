class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://ghfast.top/https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.0.68.tar.gz"
  sha256 "f96371606b414cf389b6e70da06ed8214a03f73d67645b157dc468da6e338b41"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5e8aead28ef96deb588232668661d50b90253f0c5e9cd7135f1e2033e8098305"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75b7e9fce4918057f00bdcab6c086d69bf7de2b560808c93ee695df336181971"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6550d684b95753b42f226bc66817da516a9d6eb56e8aed2d17043c214bc1219a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "749fe0da9b4d67892660354f9f81424f96014de04c85fbcce07d307008396021"
    sha256 cellar: :any,                 x86_64_linux:      "546ce748c925acbca09c04da622140503c14b0068ce3ae7d6797a642ece38a8c"
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