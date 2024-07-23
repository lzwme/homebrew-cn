class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https:www.vcluster.com"
  url "https:github.comloft-shvcluster.git",
      tag:      "v0.19.7",
      revision: "75c742cf1bbca367394ee04e3ee9f9664ae0bc56"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a59dd70c0b79dea2721cc5f4e0bb6347205407d3ebf8c8d640522c31c8f2f35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78114e8696edd390407112fca0c63df5404cfb4378bb52e5442dd5391734efab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f43dabd5c496fa9af402683aa672b6ee698012b0f5716eb3d9404166566beb9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3469d061bff3e2e802e94224b7426f46ab2b1632f4dd745948f5f68ca107502e"
    sha256 cellar: :any_skip_relocation, ventura:        "63ad088955c2da367e7d2aa995dbb4b2e74583187230f158f8c320f90f0fd828"
    sha256 cellar: :any_skip_relocation, monterey:       "96244c52f69e50b8574ae08d2e7859bae2723c7681a67ff66e5753e7ee444e33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08683cb0a870387dd1c5db8f435a27f90ad6af224ee67fca1afce1e46b6c33e5"
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