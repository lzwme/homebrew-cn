class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.38.3.tar.gz"
  sha256 "7c88ddf1f55b4801a0ba1560388db38d0b8c473ca9ddc6a4ac5c0acd68a1a399"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5235eb130e937976b0a7b1878885f5a82696fe0af90bd0055596f7d8fe39c87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99b546840bf674051ebc4c99a2abe6d55f3a7030a634396a3db3e2f177bd4f7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e75114c416a4d7cb58ee2c8c899c8e06abca4ad12eec8c9b66d0913cc1182ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "e35e921ec8dd75e9982e7c9fa0c8a6b83a0a3e445e5f6cbda6a69976ce1b2988"
    sha256 cellar: :any_skip_relocation, ventura:       "c9ecdbaf56907741c0a3d1ff185705af65f6d195a43ff7baac2fc430211e19aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce424056eb4ebf5892edf23946fce41af75ca1227ba27d8745270c177487af24"
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