class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://ghfast.top/https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.0.55.tar.gz"
  sha256 "9afd4cfc730acfcb17323ba87a4fa45acd05027eecbb1611acdc80233f8d714d"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c550217100fc241a99b82fe3990067954180b2bd272e1bb1b9032b3a12ce211"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c22772a472303cb2e382b93e2de8272d50ce66a4ec9719d71fe60cd26ad37e89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16c64c6c3e897ffe4b82872c511e6ebbaadd3806216229cc434012636f554806"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1949ad8e741b19b302581bc7a96c55279cc118f3570f3881d0d6f0728863d9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35defb457f3e877a0f9c46dc68abc926fc0bb5c3776a7c3b6ac61937fecf9371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19e89d9943b3c93db48f48d94a3e6be98b831426c58ff5cbcb03e3e9081dbc7b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/containers/kubernetes-mcp-server/pkg/version.CommitHash=#{tap.user}
      -X github.com/containers/kubernetes-mcp-server/pkg/version.BuildTime=#{time.iso8601}
      -X github.com/containers/kubernetes-mcp-server/pkg/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/kubernetes-mcp-server"
  end

  test do
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

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = shell_output("(echo '#{json}'; sleep 1) | #{bin}/kubernetes-mcp-server --kubeconfig #{kubeconfig} 2>&1")
    assert_match "Get the current Kubernetes configuration content as a kubeconfig YAML", output
  end
end