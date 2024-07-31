class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.95.1.tar.gz"
  sha256 "84f3f493c28dd7381474ef857731985d8a26c2b446316dd45ead1ed2074ae3c5"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a93c102d008574c6df4f49d78c1cd42c33ca80fcf7215ce4581949946d8d2d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08d7bf3a498580377242572ef0a2e522bfba26d0a63f31ba3f2a2fb174150434"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eac2f5c8c8ebc27cfe1e1bdc974f74ac8d1f3dec164926d7e64a6dbab62a8930"
    sha256 cellar: :any_skip_relocation, sonoma:         "41bab7b2420b1a868893f212740edb5900e2886500f1de9dc8f0937601dd4a8a"
    sha256 cellar: :any_skip_relocation, ventura:        "1d94060dd0c1180a56d05c49ff6be31f263cc3a3fe11cda4f00baf14032c4c61"
    sha256 cellar: :any_skip_relocation, monterey:       "ba7783e4c625496033938eedc099379cbc32da5d238453fb9e2be39fb9a6c510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8144da815c80714d5790e88f2f938737bf2c9e3af881bb1fe6b5561445e1a060"
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