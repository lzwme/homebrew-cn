class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.7.7",
      revision: "95d04c370d962990aeb512758257edf51e84bd9c"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b222a966cea5c5b568dcb28151056032e87ddda35d67a61e2d02c3d8423f8349"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b222a966cea5c5b568dcb28151056032e87ddda35d67a61e2d02c3d8423f8349"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b222a966cea5c5b568dcb28151056032e87ddda35d67a61e2d02c3d8423f8349"
    sha256 cellar: :any_skip_relocation, ventura:        "5780686ecd14503eeb592ccb08a2910869f52d1aed692f95a566e0ae0f8b2553"
    sha256 cellar: :any_skip_relocation, monterey:       "5780686ecd14503eeb592ccb08a2910869f52d1aed692f95a566e0ae0f8b2553"
    sha256 cellar: :any_skip_relocation, big_sur:        "5780686ecd14503eeb592ccb08a2910869f52d1aed692f95a566e0ae0f8b2553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcc059813041859abd79e5e5ad139c352f5cf2fdcae1f506eb1fd15b5427b7ad"
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