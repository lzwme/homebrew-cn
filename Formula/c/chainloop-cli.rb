class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv1.3.0.tar.gz"
  sha256 "3ced4e97ca8a087216849f9a1dece75c2779c41b12d5d465247d0c512e055430"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a36a883d7eda8f1db8d8815fb5d79b7ce24c752afed84e884aea4f8919bd7dcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a209df719870e724ffb12ccd9e619a0375beda86c75c2c36f83efad46dc04029"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb0b33318da34e85820ee8c5b094a4f5406a631982bae14ecd0c3d47d28662ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "8aafe938dcbaface4f6e8b4ea720c825de688b506c9d776a6e8d2d888e906513"
    sha256 cellar: :any_skip_relocation, ventura:       "ab17fd0570cf27ee2846db04106d83e536b4eb7b06e0975388f58228af2836ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8100b74a48ab0ff87ef69c5da588d44718673b6f93b7d875002d325f7e52ed0c"
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