class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "1a6162a0dae11bd7306a0933d5a34aa8c7ed318d45add12261ce5af688bd8abc"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4c7e2fa724a39dbe5aecbf4ae6134f31612fe50c7476abd73fe960923ddf024"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f97d2dccaadb19ae827c956afb983a3ee7dfb8b734c51de2f476f43dc073df8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e629c008fc5714b6819be5e3d2d6094b45f47ae3086fe4a109bdfccc42222b52"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ec83c7ce630f29d37d21a5885bc97644bf5ff95fcd342332e62541c74df2ba3"
    sha256 cellar: :any_skip_relocation, ventura:       "2ad380abe1aace892876500f56c7d70fec4813d0204f91efe81bc53fa915a39d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0fab9ceca222587b12978afffad34a0c7e10ec5ec4b92ca115160b73fad238d"
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