class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.160.0",
      revision: "fb500f047e6583a3fdd91271b2ad42e05719405a"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38050bff9c3297d79653727da20f636dc7abfcd4c21338c725fc2ec63885c203"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94cf590a57040607520b2022a937e8b3a38f3eed6540a3eaaf59d079b7ffa39c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60605919352b5f5693926208da61fc1e2fbb9b5d5ab48fc6af658efd82adba25"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3f8ddf00e503c3fdf3f23dcc3779123056d3ee2639a38ef8d41c863009d3282"
    sha256 cellar: :any_skip_relocation, ventura:        "8172ee9287cc6b66fbe4e44fc70fed7dfbe3da39c8a36b8c2ce78dbb07e12ff7"
    sha256 cellar: :any_skip_relocation, monterey:       "d311ada5f41ce255a81ec4a42985e2a843128b0a4272e2d5016b1e98062cdfa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c485e0c57e931a11342eeeed3bf845d06af2e184933bf53f6e6dd17811c488ea"
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