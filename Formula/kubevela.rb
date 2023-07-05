class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.9.3",
      revision: "4637e3a918c51db95cd1caf3586bd91687bfe654"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf6f2c7d380229e559de02bb4194f1e7fad6c4da7fb6618a3ad70fcd1c922382"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf6f2c7d380229e559de02bb4194f1e7fad6c4da7fb6618a3ad70fcd1c922382"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf6f2c7d380229e559de02bb4194f1e7fad6c4da7fb6618a3ad70fcd1c922382"
    sha256 cellar: :any_skip_relocation, ventura:        "5861fe028b37e819b4a44db637f918d5577f433a5b5d780b597e89cb6a66d371"
    sha256 cellar: :any_skip_relocation, monterey:       "5861fe028b37e819b4a44db637f918d5577f433a5b5d780b597e89cb6a66d371"
    sha256 cellar: :any_skip_relocation, big_sur:        "5861fe028b37e819b4a44db637f918d5577f433a5b5d780b597e89cb6a66d371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88334229d728aff1626c5a66bb9649580a28abfc81f318c1c553c29f8b454c2e"
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