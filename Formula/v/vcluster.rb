class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.16.4",
      revision: "9b2ced73214598c74429126d4f30de90d7650ce8"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a80a9e7ff6a7abe5f12eeda2c6a36c36972413c982104dbf1f9b58232e9e38b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5c163b7988693baa554892f642e6a446c39351babfc9ee13f85cbd11d505e7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12b078a2f4d5f6c4626c9fc19ea544b1985f0d917d250f6243311d258761abb5"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca2361fac70a16367e3b41f9099dfde5ea480e8df670af073de8c2b8ff470d57"
    sha256 cellar: :any_skip_relocation, ventura:        "3a58afd9c212f81917a849b5150f77566e99deb691593e8c73c54001c76c836c"
    sha256 cellar: :any_skip_relocation, monterey:       "b8c6e51827347fc080605c5394f62c95488e52ff1c375ec84c900dc998dc0d77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1731a8419b63f5e9d36605f301ba8044de96b7b729ebaee1753dd9ec5a123c27"
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