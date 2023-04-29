class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.8.1",
      revision: "e528902bea41b0c8000f7b7e81d8fef29137700c"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ecd5db237c88be093fc469021163773383f1edd965a74c79819722cd213264c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ecd5db237c88be093fc469021163773383f1edd965a74c79819722cd213264c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ecd5db237c88be093fc469021163773383f1edd965a74c79819722cd213264c"
    sha256 cellar: :any_skip_relocation, ventura:        "1a89cdb1871afe2c5bb8741ae1c3f7566229b14de2da88e1aca448fa146140f5"
    sha256 cellar: :any_skip_relocation, monterey:       "1a89cdb1871afe2c5bb8741ae1c3f7566229b14de2da88e1aca448fa146140f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a89cdb1871afe2c5bb8741ae1c3f7566229b14de2da88e1aca448fa146140f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53f0a445fcec9cd9c2552a6fbf51da2f75bec5639ce669c9a8cb76e99c0dc956"
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
    assert_match "error: no configuration has been provided", status_output

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