class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.219.0",
      revision: "7ec7c50223cb20dd9f97367f250d2e391f23c1d5"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7c1ab53a46e2535e81525716b51ea84791e1bff626c2f5073f415126caab324"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "428628646dbb73ac92133219aa214d32627cc7adcf0e3528d8833c9289a98cef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "046a547af2a91160215e536c82e9cd14fa479a9cde05b56bdacfc0fba3cd22af"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9bea9edb35e8378f2e8dbc7d9fb046836cedb6444b38bdcd327ca619ea3f268"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33e02047329b2cae443003e06d301f092d569611d399e0311bca6ccc3f74364a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71d8dd3100a5aa6161ae847384d9aecfd2af274eef0096a0ba0754f262d26bcf"
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