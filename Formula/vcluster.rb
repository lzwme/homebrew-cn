class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.14.1",
      revision: "3475fbf2a52ede5a374d4d157b6f084ad4b69292"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d29d7d9e4c08a1bad8798024622021780b349d9ea1aa262bbf954514648b9965"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "886005a25d4431b62d8c034c2cf1c09dfbbc3221519d0cfdc6a872a50e732607"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5739523d010e438f0bbbbcf36815ce6b05402d6a0d01a063b7e67274faf27686"
    sha256 cellar: :any_skip_relocation, ventura:        "788bdfc585b311abac50d4eb976d0c8d1418cac593a3350164f34d4036c6bbc4"
    sha256 cellar: :any_skip_relocation, monterey:       "eeca428507915c1c819a5a9e4a023db0c31c424c16496becd3c6b9190aa88dcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "d40dfb294595968d2e172c5041d0bf2c56de6c9035a26f900f9a319a08150720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d3525bde7ecbb184ce37b9c947e1621e30a98689d7f2a3cd7791167e53c8ba3"
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