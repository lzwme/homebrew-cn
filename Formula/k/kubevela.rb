class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https:kubevela.io"
  url "https:github.comkubevelakubevela.git",
      tag:      "v1.10.1",
      revision: "711c9f0053284595414a9742f0b54bc657560a2b"
  license "Apache-2.0"
  head "https:github.comkubevelakubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "127d9bb55521f17a2fb46585023198dcf3d19cb35de6858c17ef11095cf5f71d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "127d9bb55521f17a2fb46585023198dcf3d19cb35de6858c17ef11095cf5f71d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "127d9bb55521f17a2fb46585023198dcf3d19cb35de6858c17ef11095cf5f71d"
    sha256 cellar: :any_skip_relocation, sonoma:        "91b135785b2be968e069dfef7df32f7178d6dffcc4c095f616eb3e8cec8a9e89"
    sha256 cellar: :any_skip_relocation, ventura:       "91b135785b2be968e069dfef7df32f7178d6dffcc4c095f616eb3e8cec8a9e89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dc87260fb6c066023eef520caa18a9053a960cc1dc09eb9a9dda7434d0108eb"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.comoam-devkubevelaversion.VelaVersion=#{version}
      -X github.comoam-devkubevelaversion.GitRevision=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(output: bin"vela", ldflags:), ".referencescmdcli"

    generate_completions_from_executable(bin"vela", "completion", shells: [:bash, :zsh])
  end

  test do
    # Should error out as vela up need kubeconfig
    status_output = shell_output("#{bin}vela up 2>&1", 1)
    assert_match "error: either app name or file should be set", status_output

    (testpath"kube-config").write <<~YAML
      apiVersion: v1
      clusters:
      - cluster:
          certificate-authority-data: test
          server: http:127.0.0.1:8080
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
    YAML

    ENV["KUBECONFIG"] = testpath"kube-config"
    version_output = shell_output("#{bin}vela version 2>&1")
    assert_match "Version: #{version}", version_output
  end
end