class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.132.0",
      revision: "15bffbb0dc03f3e489ce6bfd351ca16a5c236dfc"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c8d38ee0aad036d262288eab2921087bce02bce9c3802d54b065c6591de0256"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0f0427eda81b56ebad2ae68ba87d1f0d8ac8307b81de008cbad7761014ef383"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5ae384b10714175e169feca0728ed0751b070e1b904d042e345eca9e03243b1"
    sha256 cellar: :any_skip_relocation, ventura:        "7bb554c93713935cff013b764fcf167c46794e3e56849a71c8fd4f1e48a5b9b6"
    sha256 cellar: :any_skip_relocation, monterey:       "b819674a968eb416d098566ca69da963ac3b5e1ad7ac3bb777017c18cbe6c2de"
    sha256 cellar: :any_skip_relocation, big_sur:        "d52b86e401648d2ff679cf3430a003427f5cf3be05a961c8a2d3fe9cf510e6b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "125adc479c892a6e964f5ff8ccd84a8568284f7913af5e23083c29c662324980"
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