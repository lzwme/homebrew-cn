class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "71defda121043d346386220cb07757044f707e926c1d52c9a23af53225088e24"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7f6c21f52bb088868502620ab49fda4204bc1e5f5251995182a16d6b723443a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd5c9f969a91ce394421bd62de6f7bfd7ac6f99f31ae20b68f7f6fb528d948f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6dd374d9c7df04e88dad7bf0ef4691e5ad20d0338b86ecc596a375db20c6324f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2597c02be2aa03aa6bf38e4d94cf775999c7fb247c03d4cae2c8ea828ddc1001"
    sha256 cellar: :any_skip_relocation, ventura:       "b8cce204c14cc78e86a4b57d8174d9c7758dd240acb795e8b7263665e58f09f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70e36e3542203fb8cb5f7b68f825cbb95c53d5e1acbc4b6e399196a9c84ebb52"
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