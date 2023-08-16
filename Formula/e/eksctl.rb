class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.152.0",
      revision: "07815508650e5516ec08844009502a7d64a927b0"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d293ecb45e0b41d19f4e87aeaf88bcc193f3ac0c3f849a94fa111b8d189c80f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e623425e92c2adfe6bfc6375fd433c63380d0ab93095b3966dcff4e83aa4749"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96a91f5ed51b456e963a5497d0fb18359c7a661a40b9ff1be3fd57a6c7cfcdd2"
    sha256 cellar: :any_skip_relocation, ventura:        "f2c84a2f48549ab1ab97e39515d376cb7f182cee85df9f5e56796a1871e19ab4"
    sha256 cellar: :any_skip_relocation, monterey:       "adad8fa4055e368f816a2334d4c37cd8f26dbbddd7adc0ed60ed3b621add2f0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5460e8de352691485a347c8e71b06d975062d0c06ba2dd35fcbb1005f258e6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc45e549583deb2d60c8359ba0451b58f2619d7d88470e53c222a86c7c91892b"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "ifacemaker" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  def install
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