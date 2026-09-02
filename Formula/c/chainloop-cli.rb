class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.108.2.tar.gz"
  sha256 "847eb2e83d491725c447f4142da24e2146e9f853edf00bfa4fcb086a9e09a072"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a32c50c7205c5162b515fbed3b37020093bae8b07cc120c6abde5e474c84b997"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a32c50c7205c5162b515fbed3b37020093bae8b07cc120c6abde5e474c84b997"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a32c50c7205c5162b515fbed3b37020093bae8b07cc120c6abde5e474c84b997"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14498441633a255e3cf3a72765a905aa9223ca02985f75b20e0a0aaded887380"
    sha256 cellar: :any,                 x86_64_linux:  "0cb8207bdca0c6ba34a937a1f6136b0f9c59d4da36ede56a44a84f8a727d82a6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end