class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://ghfast.top/https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.0.49.tar.gz"
  sha256 "2adeaf5f602388ff1f35c3e5a4c49324d58b524c9d9c0c3269870b73d3e02e36"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6cf228e13f0f087c5e8314adce18102956a93646323d618c65b38fa3a9264e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b20a59c82aa2d46a46d212f3c822a8d8179ae7629eeac25d62cf98bb36aaddf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f44ce5a76d9bb75238f7fced459b03f4e9efde7a56dff669cb9b87fc835efc4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bae35f8000c0171da36db0cdeda59c4370b843f40d0653043c6234977fa03b41"
    sha256 cellar: :any_skip_relocation, ventura:       "415b4a9e262a89fec153189f43c17b6bc662f27b1f033bd49a430963e5008ed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f11e52086ceba11623ff06c555042531dd9603086e5f612228b01f52a0c443a"
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