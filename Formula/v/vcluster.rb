class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https:www.vcluster.com"
  url "https:github.comloft-shvcluster.git",
      tag:      "v0.21.2",
      revision: "c0fcbf2b0544109c3f53b41864aac0a8c02fb22c"
  license "Apache-2.0"
  head "https:github.comloft-shvcluster.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a178c990b9b80c29333ff9f96100ce2fc08ace3e6d5dd30a8623d3cfe10a6fb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b73be4b7b76fa9739b842b028a5e38a87185a77e6a1a922791b22f2673a7732"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f7abfb3ff61da39e61602e0d443985d17cc1c1bf481494af4bd895435b22030"
    sha256 cellar: :any_skip_relocation, sonoma:        "a75ef0245765dee4ab4f32a2a6baa646efc7a169a88cce36e62da7867a2254e5"
    sha256 cellar: :any_skip_relocation, ventura:       "fa9712c954e839a7898cdbdaa45842e5af72c24f330bcaa50e0a5430ca2abecd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01e6ca0e952334e5fc53bd05513feae361a63c84eaaef647458193c7b99f3c04"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.commitHash=#{Utils.git_head}
      -X main.buildDate=#{time.iso8601}
      -X main.version=#{version}
    ]
    system "go", "generate", "...."
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags:), ".cmdvclusterctlmain.go"
    generate_completions_from_executable(bin"vcluster", "completion")
  end

  test do
    help_output = "vcluster root command"
    assert_match help_output, shell_output("#{bin}vcluster --help")

    create_output = "there is an error loading your current kube config " \
                    "(invalid configuration: no configuration has been provided, " \
                    "try setting KUBERNETES_MASTER environment variable), " \
                    "please make sure you have access to a kubernetes cluster and the command " \
                    "`kubectl get namespaces` is working"
    assert_match create_output, shell_output("#{bin}vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
  end
end