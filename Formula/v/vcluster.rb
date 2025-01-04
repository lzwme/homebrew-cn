class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https:www.vcluster.com"
  url "https:github.comloft-shvcluster.git",
      tag:      "v0.22.1",
      revision: "63e5b8aa6146a5121cf4f578a4364a45b004a7fb"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "180e192fddd8c50cd1d828d570f7be1a62e51497f570ec229534760fef172c10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d88bfb2e2f982538eae35778514cf3546d0cc6b693c8b5602e72690f5325d7ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3da5c2edc4ad300680e274d4d79c8a9a6a583f58cad4539c660f94e6067a53c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f281a91affb79616ca5c8ff7c8a55ec07d7943bba47b0cc6377ee284b76f5a83"
    sha256 cellar: :any_skip_relocation, ventura:       "cd3f92769f0108a2dae8bc1bd0e55b9954225526864365e7287a355557d6dee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ca9bb12ff1cf44f975e8e6c08c1c5dc86b9a3936ac4cc06f3232adc7b24c741"
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