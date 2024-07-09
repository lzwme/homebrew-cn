class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.185.0",
      revision: "94208c7b28bd6c3ee71b6580efe28189ca5ef7a3"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83c04f65a1e7353dcc2a74d7f883a15a3150c8b217b23a010e3277e30dd56fb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cea7e00125fa49a160fa80fb20f518120dab149b4213251409107257052f0b4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "476c9c86de780bf0a49e76ccfbced5d26e37371725db8391907f199e5115f5ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a3ee00d6f8f02974fba3f5d8280e6d7f02855df6f371357d9fbfc3a408ed7de"
    sha256 cellar: :any_skip_relocation, ventura:        "66dd7eb4e1339572b5ee5c6c7c739ed3559333e3ac068c05200594ea99f16647"
    sha256 cellar: :any_skip_relocation, monterey:       "37d15320c4cca3519ae17977f85c0eb3e3a378cd3a83220e159201c536098f01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90f6167f56178a8a0c24e1fb3a8be31a720b9b6125fa8d55b766920384b0b477"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "ifacemaker" => :build
  depends_on "mockery" => :build

  def install
    ENV["GOBIN"] = HOMEBREW_PREFIX"bin"
    ENV.deparallelize # Makefile prerequisites need to be run in order
    system "make", "build"
    bin.install "eksctl"

    generate_completions_from_executable(bin"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}eksctl create nodegroup 2>&1", 1)
  end
end