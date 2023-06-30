class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.9.2",
      revision: "48cf6fb10e11aed56c4e2914b34cfcb891a718e0"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10eb95e58bcd0414f5ed943f3c8ff5279ad792605f8724a300bb70edf6eb96a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10eb95e58bcd0414f5ed943f3c8ff5279ad792605f8724a300bb70edf6eb96a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10eb95e58bcd0414f5ed943f3c8ff5279ad792605f8724a300bb70edf6eb96a8"
    sha256 cellar: :any_skip_relocation, ventura:        "e23b98707d98edc815d2ff93a7837487b1bcf9ce257222659e3e2d23a1735e81"
    sha256 cellar: :any_skip_relocation, monterey:       "e23b98707d98edc815d2ff93a7837487b1bcf9ce257222659e3e2d23a1735e81"
    sha256 cellar: :any_skip_relocation, big_sur:        "e23b98707d98edc815d2ff93a7837487b1bcf9ce257222659e3e2d23a1735e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fa44b2db1f7cb25cd0f27be5661950d0162909a5cb870982ea144d0a0f1b9d9"
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