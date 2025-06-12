class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv1.6.1.tar.gz"
  sha256 "c2596a41c2f25e8fc4af0c9d7ae15067f49eb823a7da76ca7db67cd876383a70"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83b4be0d3b276b8a3075f675a03db036608cf5210eb7c9dab2ba9d76ba4c1c30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5780cc6f87543cb7a4f996a8ce6a0b580f1bf2808c14a3cd4bf302d179799425"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb0caaa683e76173dbadbf3f970933bfeb39faf00e6cdfa62f72b878031530df"
    sha256 cellar: :any_skip_relocation, sonoma:        "bebab2e80a0c5db37034840253c756237fa2faa3250819299bf1695556647a42"
    sha256 cellar: :any_skip_relocation, ventura:       "8120a1d75b5b68bd54719d39132abb15bc1d7838edf09647b6ee62d670cb0e4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92b5ef03471fbdba9fdfceeaf63356f8ababaf1be162e8f25fc25e529d67f45d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin"chainloop"), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end