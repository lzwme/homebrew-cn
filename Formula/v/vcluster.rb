class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.17.1",
      revision: "e699d8e55a8b47fc91d35055983c2d5e6ba7a463"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bca286b36267d945abd4f290e5c189e0b941ba1852232fac71c90546abc33b7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd74d35effe1eaeb1eb047130358d7d2d4c95251a12c9c31afeda08e5994da9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6852ea7d4f88e3900cb5610aa9f11bcb22bb8eab4701609d442ca121c7d31f0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a889da18bf0cf05a18acffeebca841dddae5b531c1803fb8b79d156d7f2af2c"
    sha256 cellar: :any_skip_relocation, ventura:        "b56e16ad453ffc28a8c0de759a270a1c570b91b7d669d1680381d2bad74136e8"
    sha256 cellar: :any_skip_relocation, monterey:       "4598ae3c7fe1d5eefecdb81d0a7e259796924e132c0c2ea2659e639a5d8df81e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e98dfb34c3f1a4eb59b7d1a006cc1e7c2eb99dea94a83a5b53b2e247ff823049"
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
    system "go", "generate", "./..."
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags: ldflags), "./cmd/vclusterctl/main.go"
    generate_completions_from_executable(bin/"vcluster", "completion")
  end

  test do
    help_output = "vcluster root command"
    assert_match help_output, shell_output("#{bin}/vcluster --help")

    create_output = "there is an error loading your current kube config " \
                    "(invalid configuration: no configuration has been provided, " \
                    "try setting KUBERNETES_MASTER environment variable), " \
                    "please make sure you have access to a kubernetes cluster and the command " \
                    "`kubectl get namespaces` is working"
    assert_match create_output, shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
  end
end