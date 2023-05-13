class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.141.0",
      revision: "5c8318ed582031aaf4aab19caa388472245ab30f"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e650a8fbc9f4ff7b063ba10994c21bbaeefce7fe09369f7bcf223182c818617"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d887eb05dfecc6cebc46ff3795a50ecf159e81e3d0c03c751eec96ae25997c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dedad7476e5f3bd80ccd40d04ff9368717977c3294fca96c964286a35539e463"
    sha256 cellar: :any_skip_relocation, ventura:        "34ede92d0960777f9c98cbbf499ecf519e98d30b5856f9ad172d982fee2c2765"
    sha256 cellar: :any_skip_relocation, monterey:       "0208c106df4b342920937d08a6d03015aa2c4d79a506e114576fdb4eb2be1ce2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9dcacc392da53c60daac368dd2ddf53b99a432300c14d08971069761c2510be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7e21c59b37f3e048bc3bc3062721af658edaa3f71fcc7c37b449401bcfe228f"
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