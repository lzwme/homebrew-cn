class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "027b8c33a28ef8f59bc9e4ef45c4058a9a38257e87f082a15774ae671cb8208a"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6426b95f3b9d1fa761cea78ec2264aabf295245b2668ffa50668904bba38e24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9024aecfdf0399bebf71ec37bc704087b22f1363c0d20cb5a4cac27284914c95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f255c8348cdaa9d465d43d0aca81b3e1458d90278c82b536f1b81ac00eb9c90a"
    sha256 cellar: :any_skip_relocation, sonoma:        "674faaeebab6d6f30052cdee9333954183c3577749d3e41455afd13222ef7c3e"
    sha256 cellar: :any_skip_relocation, ventura:       "01bb82e00ffdf7ed77a4edfafa5ef2447139fa3aa5d2bce61269b94f203b1fe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a0e4959b5172909e1ad7f7dbab68faf8bba88155a20f5457c6d99ae4dc22e8e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end