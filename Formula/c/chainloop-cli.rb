class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.104.5.tar.gz"
  sha256 "682c7ab866a7d045506adb8ba4dee9e07c50a4ecfde3a95bb67079120629d6ae"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0966f297293bdcba01a6d31cff18852087cf2aec5c84c66ffe9832085fa82e2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0966f297293bdcba01a6d31cff18852087cf2aec5c84c66ffe9832085fa82e2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0966f297293bdcba01a6d31cff18852087cf2aec5c84c66ffe9832085fa82e2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "19712a5388fa9ebab75680b6e2ce58c23918608154c1bac7207bc3c51653112a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "430c7555fda8421e49a9e116e9d689607a324f78419a8f4cf06d1cf0b319f938"
    sha256 cellar: :any,                 x86_64_linux:  "a3e7d4ec00e183b020d963bfa47b332da0ca25167eb7c6b6fd2cb12294833072"
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
    assert_match "chainloop auth login", output
  end
end