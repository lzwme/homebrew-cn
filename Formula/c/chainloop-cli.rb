class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.98.1.tar.gz"
  sha256 "c040e5eb592b7e1561ab45ee5571767805bda8f1cd01388365ac13c71f25a6f0"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d254043ed8c07be5ac9b09e976c7f5fa99d88cb0d8aec8b06db4f4f34be4f03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d254043ed8c07be5ac9b09e976c7f5fa99d88cb0d8aec8b06db4f4f34be4f03"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d254043ed8c07be5ac9b09e976c7f5fa99d88cb0d8aec8b06db4f4f34be4f03"
    sha256 cellar: :any_skip_relocation, sonoma:        "b680919028b332183b8d52a1ed0489ee73cb56f98b33abcee476a5ecf729f8fe"
    sha256 cellar: :any_skip_relocation, ventura:       "eafacf160f6a1792e106d21bb1d7b405313767b71b6ed021250cb26f5b0da02b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ea6ead9f950c137967bd365225852ecc952caf697c0f748b56aa53b74007e8e"
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