class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.9.7",
      revision: "b036624efc60c3b31c0895836f4a4869d63befde"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40d8eebc785627e012a827e37b932b64b1414ec2b84e40e096b97913bc0b5964"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40d8eebc785627e012a827e37b932b64b1414ec2b84e40e096b97913bc0b5964"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40d8eebc785627e012a827e37b932b64b1414ec2b84e40e096b97913bc0b5964"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b87d7d3d9b90c226135a27564a92ac13751262d04f481aa2fcb75631d3084fe"
    sha256 cellar: :any_skip_relocation, ventura:        "2b87d7d3d9b90c226135a27564a92ac13751262d04f481aa2fcb75631d3084fe"
    sha256 cellar: :any_skip_relocation, monterey:       "2b87d7d3d9b90c226135a27564a92ac13751262d04f481aa2fcb75631d3084fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08398a523a6857b9b56b1d07b45f38ba42a3502d481e9b6911ee8f48e92f2672"
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