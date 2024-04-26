class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.84.0.tar.gz"
  sha256 "cb06866afce6e186ea4d2a65c096670dbcbdd21c406b71ee39bec681ff4ff267"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a55dc4d6cc1e8229088ffe7b9bab8e654fdbfdf34a06dccd732261b00a6a756a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "555253d9b946efeaad00d4a7cc882caa2aee86202085d92d252ac7c3ec5e4d3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f13bd6cd2aeb5e012713155ffd35d1efdcd6b8d87ced44bbf24a806fbec9b8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e76b90d651f4b10f13a6c06eff1aefcbb6bba120f2d1f66c2df19eef94ce5b5f"
    sha256 cellar: :any_skip_relocation, ventura:        "1cf54b2d2a2a8cb7de0afea516f5f69751ca60b77dc3f4ac17ff5167e1f1afec"
    sha256 cellar: :any_skip_relocation, monterey:       "4ef399d6d441e7db2af592b2089b390d395598259715cce059678c8cfb2b0d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81a62b57b9fff2bc853c56acbdde13ef69bf8a8e66e1be75b16bf303fc866e63"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin"chainloop", ldflags:), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end