class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.9.4",
      revision: "b9f1cc97a9aaca0107aa98ce0916314c7d817bd8"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be349eaf2075b8a5c38a29f668551639f307194477d859b2bd37c45d31ffa5fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be349eaf2075b8a5c38a29f668551639f307194477d859b2bd37c45d31ffa5fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be349eaf2075b8a5c38a29f668551639f307194477d859b2bd37c45d31ffa5fc"
    sha256 cellar: :any_skip_relocation, ventura:        "da974cc1911895dedd373ab3faefb9f2a09cdfe6f3eb1a5e9da2869b067c5738"
    sha256 cellar: :any_skip_relocation, monterey:       "da974cc1911895dedd373ab3faefb9f2a09cdfe6f3eb1a5e9da2869b067c5738"
    sha256 cellar: :any_skip_relocation, big_sur:        "da974cc1911895dedd373ab3faefb9f2a09cdfe6f3eb1a5e9da2869b067c5738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be05a0933b4aa25ff5e3c90b65ef0f2bdce2d2a8040884f119d7b9899981a7cd"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/oam-dev/kubevela/version.VelaVersion=#{version}
      -X github.com/oam-dev/kubevela/version.GitRevision=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(output: bin/"vela", ldflags: ldflags), "./references/cmd/cli"

    generate_completions_from_executable(bin/"vela", "completion", shells: [:bash, :zsh], base_name: "vela")
  end

  test do
    # Should error out as vela up need kubeconfig
    status_output = shell_output("#{bin}/vela up 2>&1", 1)
    assert_match "error: either app name or file should be set", status_output

    (testpath/"kube-config").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          certificate-authority-data: test
          server: http://127.0.0.1:8080
        name: test
      contexts:
      - context:
          cluster: test
          user: test
        name: test
      current-context: test
      kind: Config
      preferences: {}
      users:
      - name: test
        user:
          token: test
    EOS

    ENV["KUBECONFIG"] = testpath/"kube-config"
    version_output = shell_output("#{bin}/vela version 2>&1")
    assert_match "Version: #{version}", version_output
  end
end