class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.89.1.tar.gz"
  sha256 "cdd05745dd0d086f9b01ff043af5ddc2250fa648e0e15b0ec3d99d755551a1a0"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e1ae4c91089b081c7d1bd3cb14701a4891ae62d3297475fe6ba66ad4dd1b119"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbd35410086271df0fe15927a68fdd506a3faf03af577723e4e7353af6aa675c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b001ac3c3230fed9621bceb5b28dcdd5ba718168dac696b65fe12856e42391fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "306f5ad068c20a4c2e7a63f365b54787fc59cd951d9eb699f7527e9612451ba7"
    sha256 cellar: :any_skip_relocation, ventura:        "555990d55404b8bbefab1a8c7b76dc8e2ede16d14480d074b2629c0ee22d31df"
    sha256 cellar: :any_skip_relocation, monterey:       "c1ab7b80f544d71d77ab8fd347ea869aa72786e0c70e19cc40e16c5e7c4bdf14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62a28b178bd60e6ba0bd479a4ddc8a8c2cb31ddc69bf947794fd8355a7ca4971"
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