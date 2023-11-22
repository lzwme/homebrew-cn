class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.17.0",
      revision: "1c6e3cb9594300b75a45bfe0b1d9004a3a98cc6c"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5ce41eb57cbf14ef251556a4caf938a353364a23f1ae5ef2401f18340c74b3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bf50ebc142b2fe78c4a2437ba89aa926c161be59d192c5789540e0f9116f1a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b04f04d2f9447fb7293555dbe4a6c6f96a083b904f97b926bf43ac308f4f6865"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3bc64dd6a9b1c53db127de669da71e06c43fe876c7973c58957502d027e8b67"
    sha256 cellar: :any_skip_relocation, ventura:        "ba7a591cfee8f9d4239e232433744c74352bf132ee17db981344b9ebe809f6b6"
    sha256 cellar: :any_skip_relocation, monterey:       "f942a91c67387dacd3c9d5b18ffb1bc7507d5b92f6929736a0a31783003b9eed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83e178f5c40dd4d68b4a04d79639837d74ed27a20074533b9ecf9edd4aaaf56b"
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