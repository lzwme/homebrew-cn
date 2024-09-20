class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https:kubevela.io"
  url "https:github.comkubevelakubevela.git",
      tag:      "v1.9.12",
      revision: "89c1d07a8fa4ff7e43299276af0f979d3b6bc875"
  license "Apache-2.0"
  head "https:github.comkubevelakubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e17edfdd66e2b3b372e21dd249c25c76d8a9c8eda77051a08c96ff1159cd4ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e17edfdd66e2b3b372e21dd249c25c76d8a9c8eda77051a08c96ff1159cd4ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e17edfdd66e2b3b372e21dd249c25c76d8a9c8eda77051a08c96ff1159cd4ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "9135ac9e7b598fe358336822647a662f1334c87f103835b9e8e9936c45339a60"
    sha256 cellar: :any_skip_relocation, ventura:       "9135ac9e7b598fe358336822647a662f1334c87f103835b9e8e9936c45339a60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14cda129b4c2b09a4a5b5b22cc8827891213bf4c623ad92d4c668b8a9780599d"
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

    generate_completions_from_executable(bin"vela", "completion", shells: [:bash, :zsh], base_name: "vela")
  end

  test do
    # Should error out as vela up need kubeconfig
    status_output = shell_output("#{bin}vela up 2>&1", 1)
    assert_match "error: either app name or file should be set", status_output

    (testpath"kube-config").write <<~EOS
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
    EOS

    ENV["KUBECONFIG"] = testpath"kube-config"
    version_output = shell_output("#{bin}vela version 2>&1")
    assert_match "Version: #{version}", version_output
  end
end