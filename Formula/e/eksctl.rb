class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.216.0",
      revision: "a204313b2263caf8ed86537a3e83bb9575d70851"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a057462461e7b189ac19ae402c7f5df293d5bd2a04e37277fce2e348d640d47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f1ebae588edfec2d228f01261decb66dbb264f16db14f0fc47ba55cff53b8cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "153f9c4e2f91b653a515f96910efbb0b7f2795c338a924be043890bf45203e97"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f28eb1077508ea325f0257b50330884a434a3ccdf6e32f350ecfdde3cb8c7aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af12e91e50a02d46a9099ffbd9e8447de8719f952d0de50fca726d40c48f233f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4397dd92d729f10fd682513f002dba0e0419a75b605be0f13f211ec0fedac4b3"
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