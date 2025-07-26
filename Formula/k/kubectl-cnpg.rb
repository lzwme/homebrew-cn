class KubectlCnpg < Formula
  desc "CloudNativePG plugin for kubectl"
  homepage "https://cloudnative-pg.io/"
  url "https://github.com/cloudnative-pg/cloudnative-pg.git",
      tag:      "v1.26.1",
      revision: "252497fc9092a8b48bac20356026899627d31c8f"
  license "Apache-2.0"
  head "https://github.com/cloudnative-pg/cloudnative-pg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efa501cca7d20788c1e2143d4dc095b5777ecdb3575a71bf7f9785b54592611b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e89b15fffd00630203389e756b41ac59b5abf30173b27c8182e3363b53d05d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8363966695bdf5e1a13b7ba6d2bc0013550596db6ddbff8ec872a23504d1d8b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2c962656baf788ab13cedb7e156e16105fca4ea6f060db8764e884c257c2104"
    sha256 cellar: :any_skip_relocation, ventura:       "1ca813f5ea4e556eb697d6784d2b076edb63d6637fcede20e9a9578db05c547a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cb5ded0fdcf264bd7e72688bd5d7555ef8ee8dfa85a42e091a8d48a73ecce71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a908a5fa6bd9211df8e4dc47d5e437373e4ec0c0f76659a9535f4cc8c6bb6dd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/cloudnative-pg/cloudnative-pg/pkg/versions.buildVersion=#{version}
      -X github.com/cloudnative-pg/cloudnative-pg/pkg/versions.buildCommit=#{Utils.git_head}
      -X github.com/cloudnative-pg/cloudnative-pg/pkg/versions.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubectl-cnpg"
    generate_completions_from_executable(bin/"kubectl-cnpg", "completion")

    kubectl_plugin_completion = <<~EOS
      #!/usr/bin/env sh
      # Call the __complete command passing it all arguments
      kubectl cnpg __complete "$@"
    EOS

    (bin/"kubectl_complete-cnpg").write(kubectl_plugin_completion)
    chmod 0755, bin/"kubectl_complete-cnpg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubectl-cnpg version")
    assert_match "connect: connection refused", shell_output("#{bin}/kubectl-cnpg status dummy-cluster 2>&1", 1)
  end
end