class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv1.2.0.tar.gz"
  sha256 "816dcdcae2ef52fec23b44fcc6dc7e5662336c8bedeeb01fec3ba5cfa8ca35c8"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "153dd49ed71604732274ecb719d59782dcedae44c91e488c6069abd93df0ea0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc8aa07b865762299cf05524c58a8335e9269550a99b4015a2a9e357cb94a45f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5297143aefef94843e40f911fbdb1e9c79fa4796bb4a802197e5799dcb95d5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d529f8190293b8f7152dcd4560e1f8860a9182269bd4db79d0185e85a0ef527"
    sha256 cellar: :any_skip_relocation, ventura:       "3ed8125e302870579184ddf5abc193dba5f6ec035d53be7739d32e47dadd09b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e809a07bc86b8bb185f0e1f51f0886febe9024397b6d7986168f8b3323a7c0dd"
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