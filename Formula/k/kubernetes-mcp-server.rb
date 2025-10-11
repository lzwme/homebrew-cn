class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://ghfast.top/https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.0.53.tar.gz"
  sha256 "5611239695cc3a25c24ececa7a7e36e5b60eba7b26fac7d15128cfe4a735a929"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5a579445171f042ff81a3ef5b6dde79fdc7bdaef683699729631663e0108cf6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a775a6e6b37087a57ad076da8c88e81a8c9ccab1eca0d2929e85f3216fd6072"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22b45f2b5ed588e440decc4d12ac6421b779b6c47b736a0babb20596b043cb4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa3e914711f0839a03901168a162d127de4ec49639617beafd3c77a4fa9cc369"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73c7c154d9c223d949dfd51a36638f5848269e34659d076b1b2265b879dcb195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af9e199ba4dd7434962b378162d84c424cc69f3c1d63254f03aa21ebf996cab2"
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

    ENV["KUBECONFIG"] = kubeconfig.to_s

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"kubernetes-mcp-server", json, 0)
    assert_match "Get the current Kubernetes configuration content as a kubeconfig YAML", output
  end
end