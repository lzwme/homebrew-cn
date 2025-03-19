class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https:www.vcluster.com"
  url "https:github.comloft-shvcluster.git",
      tag:      "v0.24.0",
      revision: "22a00a7e510f6f3863322a49d550206dc116793f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d93c593fe04b6f4e6e7838f6034af673abef532f0599cd5f19c562b7e08b73c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdf27587dff87b3940242cd76afb1b7dae0719394335ae641d9c98a0aba4fdff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ae371cb67967ca90808957c9b07b886116ba1e5f1ac86b8446324bc8ef65fc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9ddd1ab25ccf72484e8982c74672f63d1626decfd1eafa16db26f874ae6a06e"
    sha256 cellar: :any_skip_relocation, ventura:       "0fa71d49ee5f969a9e82c620c38de62559b9a009ab90010de42f8688d0c7fd99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a2e138aacb85ec6c6ff6fdf1af79a5ed2c24faaab26a85429c66d43c7ba468d"
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