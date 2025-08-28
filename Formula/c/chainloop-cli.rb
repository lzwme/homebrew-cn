class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.43.1.tar.gz"
  sha256 "17ec5fd1ee2b3d4fe4b33883e73b27ad440e2d0995d8e27e8d98653c3a50c8a7"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9973399b837bcc371f050cea5c7bc6e3aeee45391794a81b75df8b353d55e88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b106e70d95855f2807d3ed1750e2f110b6852ff4576783df983e38e39499cbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a627abd78704006f7245d681bda11bfa1ce9b730a18118b6a6a1dcaa7d18e46a"
    sha256 cellar: :any_skip_relocation, sonoma:        "06d2be3d0d88aa3637f6bab53ed834e141eec0e8df33dcf3a39fc76f01a32d44"
    sha256 cellar: :any_skip_relocation, ventura:       "4a8c1eff091d62461ba750a18e8704fc720cdbdf3860befeffec45b7af58b4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a3831ce46a41b1945636159687f37b1984109b948042e30b29c90e8e201a12e"
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