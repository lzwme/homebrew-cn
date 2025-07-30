class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.212.0",
      revision: "db83da480fee7a0a8c6058931b9e829bc00079db"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd2e3f4829a9218812c54ec9c1c31282ea8d1da26959aa77bde4e09a88b21ee1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac9701910c63fbef5420230d12e6a95820c701aea7f471651000b3aa544e2c77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a055282a4e3979ade7983bd8210ed90be2b363893ee4327280d285ccc2f4600d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c6de35ae38cf0029a102c2e15ccf68b286dc0b65c6f969a5b70ca8cb2f4615f"
    sha256 cellar: :any_skip_relocation, ventura:       "5e00e7c49ba2a044f3bbddd3309f7bbe0e8fd36d7f1dccd4276c1e348eb3ab96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c903d713cacfbfeab71a7c04962322506af767cbe1256d979618c59ab64181b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb5e3bed11fe01a3b4eaad5c2c4c543392fcb16fd3cb5eb4c8fe4f7eee016b7a"
  end

  depends_on "go" => :build

  def install
    system "make", "binary"
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