class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https:kubevela.io"
  url "https:github.comkubevelakubevela.git",
      tag:      "v1.9.8",
      revision: "62efa9c78744070aa3cbdf097d4440610f15ffb9"
  license "Apache-2.0"
  head "https:github.comkubevelakubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88d4434a90dbcbb2f7bbcc4ea05c5e0a4ddf77e002e486d526fcc8b91c4b4bd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88d4434a90dbcbb2f7bbcc4ea05c5e0a4ddf77e002e486d526fcc8b91c4b4bd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88d4434a90dbcbb2f7bbcc4ea05c5e0a4ddf77e002e486d526fcc8b91c4b4bd9"
    sha256 cellar: :any_skip_relocation, sonoma:         "9869c0f327289c8ce1d148dc74c3a75121955d7feedc32b92811f590766905af"
    sha256 cellar: :any_skip_relocation, ventura:        "9869c0f327289c8ce1d148dc74c3a75121955d7feedc32b92811f590766905af"
    sha256 cellar: :any_skip_relocation, monterey:       "9869c0f327289c8ce1d148dc74c3a75121955d7feedc32b92811f590766905af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cb6da345679f83fa6d177a8847f52643cd476768570c91ad01eb5dde42da4cd"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.comoam-devkubevelaversion.VelaVersion=#{version}
      -X github.comoam-devkubevelaversion.GitRevision=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(output: bin"vela", ldflags: ldflags), ".referencescmdcli"

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