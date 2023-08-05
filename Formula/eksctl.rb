class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.151.0",
      revision: "3a70858144ae218834f268da8209a5ba0e77fcd2"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a54125fd3362898f3c2d57f9ce7af0ef6b7c1445dd0969a97cdde0d7e7ce0e49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1040e5480858d39d642a02e04e90994d6c7c1fd61ac2c1c2df8d49c9a5351099"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a70ebbf7cb2cdf142c374327eb0e0dc13a0f76eb021580f00411fd612423d439"
    sha256 cellar: :any_skip_relocation, ventura:        "84563e6436b5593f922b7fcc8ff42d4017fe91e1f70c63fc2b2bafbe845fbeed"
    sha256 cellar: :any_skip_relocation, monterey:       "07b32862138a04989fb1094726c4fba48814addb30a072bec96c0b20fdfb8a0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "462a53fede3577915950d298ce5758e865c45baa8572c4a95e8f639427943dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a92cff2678889b87b61216b929c830aed7987ec7e3c9c2c63feb1e08196a8f9"
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