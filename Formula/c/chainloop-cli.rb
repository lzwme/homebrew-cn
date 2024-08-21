class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.96.1.tar.gz"
  sha256 "27377fdcc46997ffa2b9be9df7b56d9a2cccf9a00697e88be9cb06a5d6a4e5ed"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90930c7591f473f744595459af59ccad0d72ec432f3379d460f548a983de030e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90930c7591f473f744595459af59ccad0d72ec432f3379d460f548a983de030e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90930c7591f473f744595459af59ccad0d72ec432f3379d460f548a983de030e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7a479b03faabfa674af2897c75058c2f8163c37c3fad4405356dbdb29a61067"
    sha256 cellar: :any_skip_relocation, ventura:        "13a629409a47b84e506e66fbb5a250d19e214a5f62becb589abeadcf4b548846"
    sha256 cellar: :any_skip_relocation, monterey:       "201ba61e65f3253194c70ff4d4fc2bb8123b584a13ab6bc58cbb8ae18ea0d0fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efe943ed7dedc7943575d453ee45be5bd947a84062aec98405e9eddc5dd524a1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin"chainloop"), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end