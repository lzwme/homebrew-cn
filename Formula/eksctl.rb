class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.136.0",
      revision: "3f5a7c5e0f7a13c534103ad297a04823bb6c3998"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83257628a71cdb98111dfff42d17838e043949cc298d410fed80d729b9c55d46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fe6acba640303233f672e85f022a306da37dc48015cd3e63178bf339fd562fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd0ce48776530ac150908dda163ec7ee83361ee9aaf6647e38f6cd093f965674"
    sha256 cellar: :any_skip_relocation, ventura:        "6c5e3239f05fdfce1da6982181d33c302555c6e2a6510e2e195eea7dba1dca3b"
    sha256 cellar: :any_skip_relocation, monterey:       "c3e8c37475a70b174fa575a31813184d8242021633006b0cd14e4bf37f75c064"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba9252141a61923503ab15c18fafdc715408391c8a178723596fcd2ca889804c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89114b3ba38e19bd3440984df3fd4e1666538d21644cbe6a098d6a1b6796e5b1"
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