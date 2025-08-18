class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.41.1.tar.gz"
  sha256 "33696cb68575165e04bcbe531ecb8f2abef4e48dbdf0d3c7c698f18e8cd99a87"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72a89ed967432867b0849d82bd23d80eed5d5262fbf0e0d2f507aee394d9f5dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be1149a152da0fcce2efde573cef3bf8c512b1dd1623d817fae9eefe624ad3e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a33e1843f4c1232a1ea67bfdd118ff7adcfc8e434e81ba9c56cf0f2ce703c27"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4c13b6fd1dd1898e148477c4657183345c774d9f6afc27df90ce62654d39eac"
    sha256 cellar: :any_skip_relocation, ventura:       "0b891acab370fa0132ba0e7bab5432fee8e5820d39e3532d3f9279836ce48b79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e44e9acacef180066e12b99ab67e65b8f435a0c1bc426e4bcbb9067b1fe5125"
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