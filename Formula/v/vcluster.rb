class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https:www.vcluster.com"
  url "https:github.comloft-shvcluster.git",
      tag:      "v0.23.0",
      revision: "36839e42e1e8eda9a64c2d8e012e4658d2ff1ac5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de1e121930956fc9d91d602719b2a16d8cd05d722946603f670f90227c353323"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfd56ed710c03b72b0488df988888c97ac582ba0fd77d81e0079fd937440d2a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7257a5a593c5effe72ad959c997c9c10d9b213fc7a52ea8c48efc892ceb1ae35"
    sha256 cellar: :any_skip_relocation, sonoma:        "11b99cf253ff84beb215a42d2b8748d20e3640280e7fd5791b05fe098782318c"
    sha256 cellar: :any_skip_relocation, ventura:       "4ba6fe33e75389b20e106c2427965a478389c709fc2b68bf8ec3884fa3b09780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbb117b96d5d1bf3c0cb4730c7bdc9e5d53f49f415791a14c24d909a0ae1d1ec"
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