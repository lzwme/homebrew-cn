class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.9.5",
      revision: "00ae0c9494e0672e8df0c918f0f5d034e29ce2b8"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ecd315af27a4581e628b43198588240faf7464dcc9149c4261882ab10c55305"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ecd315af27a4581e628b43198588240faf7464dcc9149c4261882ab10c55305"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ecd315af27a4581e628b43198588240faf7464dcc9149c4261882ab10c55305"
    sha256 cellar: :any_skip_relocation, ventura:        "f48b0c69c8450242cb1db419f4e045823cf7ff046abb68683060f42cd5160d3f"
    sha256 cellar: :any_skip_relocation, monterey:       "f48b0c69c8450242cb1db419f4e045823cf7ff046abb68683060f42cd5160d3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f48b0c69c8450242cb1db419f4e045823cf7ff046abb68683060f42cd5160d3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce9d7889acd391f1773c71c1347796f761fabb08e67ca2a1e90b111f9495ddb0"
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