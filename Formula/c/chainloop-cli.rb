class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.108.5.tar.gz"
  sha256 "792c571a0c262b3b01e7643248ae07dcdd68c85ee76bf35086d5296fcbde8dfa"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e981f389ed95fb4310f82e57f5433eceba65f7d29a752234924f6f5230127913"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e981f389ed95fb4310f82e57f5433eceba65f7d29a752234924f6f5230127913"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e981f389ed95fb4310f82e57f5433eceba65f7d29a752234924f6f5230127913"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e313cf2bb92d401c9b8dce93b212d094a05c08931fcdc6f49ab31c354a4c1d9f"
    sha256 cellar: :any,                 x86_64_linux:  "5d9417370e32cad1b816a8c8dd21d4bda380473d6c9d661968526de5c2d3b54b"
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