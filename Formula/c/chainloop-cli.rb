class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.70.0.tar.gz"
  sha256 "a7d4be1ae48eabc460c56bff9de69b963b26cfc884092fcb2537cea16dde77a3"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca74a0848fa5255bfb77e38e640b1000139305ea57a48fbfcb98e8265037ef8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b220501c29debf37800e5dddfdda49f4f67b7da56fb4b22fa115fbe3ecce94a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d99a8320d097e89a75eeadae5aaa2ac65c42b3dc76f00bc7a497b9b53dc1e87"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f5f5be814219e2c82ec55a6667ba609e277d4e584ff57c115777900ca97de7e"
    sha256 cellar: :any_skip_relocation, ventura:        "41a33fb302dc192fb1b0e74660d3668d425fc927697381dc01e5623d476efd58"
    sha256 cellar: :any_skip_relocation, monterey:       "f121db48867be57e3556d2181f32d1e09b478a8c94050d17425c8ad7ddff25d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee187537e7c8ae9c6265cc28890b765815b21c28661c09f65c8525c73d80c152"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin"chainloop", ldflags: ldflags), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end