class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://ghfast.top/https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.0.50.tar.gz"
  sha256 "5a7351b8c495abd9cf513d717a7f4fb6fe92162ae832eb429b80f66d5323dd48"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f90b7246ac0cfdff06b87cd1ea343d68d90ab296f94192a9b81acda3402de01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e4f62547941e8779d018e48c52f24231cb14a32f63a368e5341c01f61ebc9f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7b6470b256e2b6edd2dcdd01261221b9cf1d739389023ce6d37a8e99066e15f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e65e8e558eefac0a47e55863196682d8e898ae70647507ef8f9857406d847896"
    sha256 cellar: :any_skip_relocation, sonoma:        "e41383d56ef5138cbcf298ed738df7a1a448449f0feeb1790b7511d3da7fffaf"
    sha256 cellar: :any_skip_relocation, ventura:       "9635402d5dec6e1c58b8b3141c0258499ae0a4c6f4160b22a0857933450d61f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e4491ff7a027fde60fca90dcbb63b7233b131bdfaaf3b3a44e464f91337d00b"
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