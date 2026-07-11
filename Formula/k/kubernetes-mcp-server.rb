class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://ghfast.top/https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.0.64.tar.gz"
  sha256 "4af96582d8a4c842b0681bba75d8b00ec1c252a0e49357620ca3a209d270d1cb"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64c705c492075667cfca1254afca60c4c133454d657d75dbe1940e7bdea3696d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d077f1bae3c14ce0d3b9ecc4a0f6232d6250dcd1b0c40b6ec2ffbb06871b97e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79b7a2d1b07d75c859b41904b8bc44ffb0af9fc9090670b4fe8e635acad1d99c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e51d7914e6e4552d94fd0f52f88083caba02e44acb6758a52a48c139d568408"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b83221052d10d54549bf0a62539a698ccc3e6402b0e9fc585e8894649594d92c"
    sha256 cellar: :any,                 x86_64_linux:  "563bbe1fb6812c003fc2d12ade9cd25cb8f06fb3cfbf8fb677a21a44b6ae58e4"
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