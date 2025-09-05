class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.43.4.tar.gz"
  sha256 "16664c7806f3e84f9e238218b6048d52c11964b5c1ffe4b15c1ce31163e6fa40"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "010c31c04d29146fd3774da321d6a713e135eac0592fa02f5ca0ee4ae04b3480"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1c5298e4a7cfc7b0aef28c228c3daed081cf3d71e47d7457be31da748950110"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "994d7373afd4f795f1c1c016b9d84d605adf80a3b44997da4685bdae81af0cb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba7a1c76e41b756c0d7202236ee7f60ccc688681b20c26dc6626d213b1fc19dc"
    sha256 cellar: :any_skip_relocation, ventura:       "555b3a90a7996e64b9b44a5bb4cc00e4aa242a51173a585da65cfedd4c71b2a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4b7756f877f186256527eb1274710ab98d0b15bdc561341a5501ab31dce66a8"
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