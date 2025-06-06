class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.209.0",
      revision: "d3e4061dbb04a19ba1598d9ce2df5d557ec33785"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c10d6a007ef3225f1c4b38de2e6ce3a13c6312c4f1e6f55b9c1156702e1eb2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73ceb55e6964143baae23828fb7eae278961ddd3a2e5f743dacb73fefabd2047"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ad4297afe57964a81f0dbade5c0751c320f17e15c52121c9507420f0d27f6ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "98f8646c7908f03d701ec46c62e69fcfe69515682668b290ee11460a1bb5261c"
    sha256 cellar: :any_skip_relocation, ventura:       "0769304e8a6aeda9cdc98c94bb23211b26ab3ee577371e37a04ce893ca810123"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "406da21c49f5bc721a4894b1bb9a800d647550f43bcda792ee34e67bc00cb82b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ab232a66dd4324eb18230ff1fbbce8b2c6690caeb32413e9c5c485e2a2ca49f"
  end

  depends_on "go" => :build

  def install
    system "make", "binary"
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