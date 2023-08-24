class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.15.6",
      revision: "0c5f33fe0bfae62c5a96dc8b945bed7a55fbedbf"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10f64dca1fc575ca1058872878e69bb67b60a47aad594fa0ff8d71c8bd937535"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9180bd4ee3da8c30d8d2252ae2a28ae451dec50370a896e0bb1c3157f2b215d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46bd8f44c6ce241092bfce0fb8b6533c8de5f8db40750f4f412fd2341a3130c7"
    sha256 cellar: :any_skip_relocation, ventura:        "57e4235c98d118286a6564f12abd89997ed7b1d6768e7f5a90e9735f1354e30c"
    sha256 cellar: :any_skip_relocation, monterey:       "3ef0e883e016314892ebbd589ca69b7317c082dc0bddce37bdf837627df4b8c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f97e7fb6dd03e79c045bc6ed6e93849cfbb4bf103f08ca7a612760a9f89919e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21d9dad0a4f3547393e8659f3005791851e58cf5b632e15491f751684d775e4a"
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
    assert_match create_output, shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace", 1)
  end
end