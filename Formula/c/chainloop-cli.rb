class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv1.12.1.tar.gz"
  sha256 "56555e4184f4e2dafdf6e84b221bbe87f0979405cbb8ef2f407ab62541f83f7b"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e7ff0b8d62224d8516cc443ff90bb2801096aed253499894658b270d7cfb466"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3294dfcd39f2ade19d8e34cf6c3f4ecb77314c8d1296e01643a4112a071c9864"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e3ed3cf9f7fdcd00a8575f678b8cc9edf35922283e2b6f244145828c5157f70"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f19f35a67ac21f32b46192f8aba5943f1dae03cab7f38caa2a8b016b62019c3"
    sha256 cellar: :any_skip_relocation, ventura:       "4915bfc474615951c72041384fe586f6265c0c8c2135b7a27b0a2be503a51740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9ec87d084582e776b16fac5a30e3bbcb1f3408f5617ebc7bb3948e39cfc412b"
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