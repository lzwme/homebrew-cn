class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.43.0.tar.gz"
  sha256 "a1f04f16cd827218a1c3e2ca9beb12868324899a59a6a89d1057d2c08e179f8c"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb0d474660a061cc15cf300a6406359e201cc51d6fa4151553e07dfe0e130065"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d5fa517b7f11b60a69941fa4bda6600a2068b90520eeb2210ccee8175d0c898"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c416f6543c406fcd956db86ab6245fd4427b58eb8274241a21b7455623de69c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba3a81c639a682b2800f0e5f725a02b732155dc3df9a363676f3d42ad9e31ff6"
    sha256 cellar: :any_skip_relocation, ventura:       "9c24d83db2e88ca30eec7d595a88f9d568088179bd2687a5de9364b94518d620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04d0b7699340cec9f791455cfee7002af965210421a1ddf175b22510255c1c36"
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