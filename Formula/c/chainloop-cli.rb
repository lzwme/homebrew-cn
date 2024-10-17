class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.96.22.tar.gz"
  sha256 "d7f7d10af9b0f3b7226006b89add11e48bd2bb9d6aa579f784b213924c791d00"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "516760bd29138f8858a931388507faf4c0a70680f610120ec9816bdd6d6e0cf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "516760bd29138f8858a931388507faf4c0a70680f610120ec9816bdd6d6e0cf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "516760bd29138f8858a931388507faf4c0a70680f610120ec9816bdd6d6e0cf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "db8e4874e79b6ee46a928751e03c999caa834418eca207b92b43745172ef59f6"
    sha256 cellar: :any_skip_relocation, ventura:       "fed3537ca7cb4862fbc95f6bf8d237824fa923a235b688d678e242a38a2f3fe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf976b92337026d6df8f1c0bfee3c6e428cd6d30732e162c816b12d0744082c3"
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