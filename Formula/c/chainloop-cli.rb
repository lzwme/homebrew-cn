class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.101.0.tar.gz"
  sha256 "45e3957b92328dda8e0834f4176c7a623352cfb5eef3834059d696eea8952ff1"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d2650a6f70c2fdf673fe45f96b2969bd7e7fcaa2346f360c45b414c3af1345e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d2650a6f70c2fdf673fe45f96b2969bd7e7fcaa2346f360c45b414c3af1345e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d2650a6f70c2fdf673fe45f96b2969bd7e7fcaa2346f360c45b414c3af1345e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddddfd04c07d21b685fd7b8955fcb6a43ea2ba2ddebc6c51db9b12111e56c8e7"
    sha256 cellar: :any_skip_relocation, ventura:       "61f7e9bfc1ae15b658943802e60ae7b9a6d409aea4b28b742d5c75cbd5e11194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab773fa1591e53362e07a71f6e6274a938abeb451147e31da383f14d34966ee2"
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