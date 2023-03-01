class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.131.0",
      revision: "d4917e5d1ef8b98484002869208d0b9a41f95173"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ba6a4cb594925bf7992230b52be6de32cceb7db50f415fad36395ef7b3a07a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d24541482ef067ccfeaa51bf50c8678fd5a32efd8d305e5ec755cf6a614a0e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3f05267a720783355455ba439f2d751e89358d03c6e25b4c21d32ff55d4c943"
    sha256 cellar: :any_skip_relocation, ventura:        "1e1fa3af26f7db562b91a7b9277dc6e553645f022490c828dd74599b31f63d3c"
    sha256 cellar: :any_skip_relocation, monterey:       "4cd4c54135550a4be27a5bf05556f999c964162628294b314eab51c48c1b61c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f018bc3152d1ae79975958cedcfa6361f05b1b4554f4b18d44f82a44279ab512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0eb766736ed53272b620863dc8953a67d5525cac3daf01d0dbd258abb241763"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  # Eksctl requires newer version of ifacemaker
  #
  # Replace with `depends_on "ifacemaker" => :build` when ifacemaker > 1.2.0
  # Until then get the resource version from go.mod
  resource "ifacemaker" do
    url "https://ghproxy.com/https://github.com/vburenin/ifacemaker/archive/b2018d8549dc4d51ce7e2254d6b0a743643613be.tar.gz"
    sha256 "41888bf97133b4e7e190f2040378661b5bcab290d009e1098efbcb9db0f1d82f"
  end

  def install
    resource("ifacemaker").stage do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: buildpath/"ifacemaker")
    end
    inreplace "build/scripts/generate-aws-interfaces.sh", "${GOBIN}/ifacemaker",
                                                          buildpath/"ifacemaker"

    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    ENV.deparallelize # Makefile prerequisites need to be run in order
    system "make", "build"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end