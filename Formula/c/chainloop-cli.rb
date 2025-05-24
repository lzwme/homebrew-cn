class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv1.4.3.tar.gz"
  sha256 "de77fd73c25c8911a5d66817fd1690528cdbdbabc60a1aa8dac2680d712c39b9"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d0b0ecf5fe20f96bdf22af54372e1d70bdf0318e1c8423fb630b79061bdde12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf6843c79776501337e9e6fd71aa1669bf1624cee80d49542251dac965c08daf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a0f0b256fb6ad7256add59b3c20870125c61fa2d3b1c34ae94a4ce92680a131"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba4c5b552109f56c8af599f2f492a323d0a8081e9cfbdf886cc2dfddda1167f8"
    sha256 cellar: :any_skip_relocation, ventura:       "4cc88456e651b688c6dcc8601901a2e47ddd1d615fa563f222a76aa681a74dde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd42b9d8dd1d837c2486613340704756879aafc318a8ea003141d8cfa827fd91"
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