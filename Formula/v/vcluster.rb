class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https:www.vcluster.com"
  url "https:github.comloft-shvcluster.git",
      tag:      "v0.22.4",
      revision: "c90d46b080f842d24fe286651b69601c006697e9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c101351b4c5191ff35572436bb1cce063b484ff68aafc1a83c6a7796439b500"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ca0bf5484d9796e4f9c02c420a283b4059c07688fcd033d924d69a40421ee16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16124d29d9af8a8c15e933ae926ffb21361fe2e52ec1d8130ca1c9112345ed85"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2a2444d64fc1a69a038fe85e34178b13f6a6c34d6d7e38128766016e1c9a71a"
    sha256 cellar: :any_skip_relocation, ventura:       "eac84aa10526dffe46b4a883d2932cdca70bb04ca85ffd6bcd08e6a09e923e2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbd521ea8564bf47803ee2ef83489a27965f5af8fcf10211c3231a1d43f090e1"
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