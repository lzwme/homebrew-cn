class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https:www.vcluster.com"
  url "https:github.comloft-shvcluster.git",
      tag:      "v0.21.0",
      revision: "0c5dde79d5d8aa811c34b3869695e389309948af"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ab22682d2d624a93dfd67049ba7bf6e8763173050dc71e4f26eb37b108e786a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34e56c1b2147bb5c7755104233d6a4481c1be3c2d7ebbbe1a64dfc6c87c0b7aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dfd4f8943b1ffd72d1abf9b3a8ff1a478010de4605e0e64dacad188119b2eeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b2148eed86827baf42c434e6ec467940269bfd352526c06cbd2318973fa601a"
    sha256 cellar: :any_skip_relocation, ventura:       "0663bc672ddc9f4773cee8089cc03a7e6bcacd51788864c41448a3b39cf446c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca9c921707432f9d370ac570d85facda85cb23431df0a9bd6b9c925c3eaccd12"
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