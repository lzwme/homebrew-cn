class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.71.1.tar.gz"
  sha256 "446a0871c1dc7efd8fde21a385c71c25314754ff746c8697f5fd364186db3423"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95bcd9ef48ac8943d3c9e8cd76f7c8e49f6387b7f7637abe5369d449cac92bbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b97e292a9e2704afbca1452aaf244bbc59a61ee2a0c449449858e35ccab11dfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08c6f0d5c38f23203d045417245dc865947e3084363778c86b40df134aa7f56c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a910b5ff6481c34b14c97467ebf26f2bcaf05e1ff2928f0029faa28f20d23d36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69e43b89c90c3ece656f1fa6250ecd1666391a21be884f868f960781218e4d50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dd2522d977259f56bcd5f80231b968b4a88b6340b4db8920c792edebd9efb78"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "run chainloop auth login", output
  end
end