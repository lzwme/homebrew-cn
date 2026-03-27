class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.88.1.tar.gz"
  sha256 "b4634795f198174c2cfad08e9820dd6b5678193599550e7d93b189afadc4b964"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08306ec4aaa41ee014a250e83c7c16d787451761b52a525b8a4997bd8f1bc65f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d7439dbd63b8a038120fc0de9779fc0b127726fb64b539b952d72c98cc582f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e176be86373d90e7b56261399d34886f53ff3835bfad4dba9c7a876831292fc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "447c6c4e4a51045ce7538a725cdb2cbfe75afc4701cf9d4499ba92dccbf2f54a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cdaec4297433c2695b4f53573a5d6971a1cc7d2b80803364652edd7ad615979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47e566573e87ee6dbbf722cce7a5dba43c31898c8e2c45809a2db2ffacdd8c9d"
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