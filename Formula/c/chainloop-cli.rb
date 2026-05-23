class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.98.4.tar.gz"
  sha256 "3f7a19543182a0da9dca026eae0cc5d25f5c0b447bb6ba37e4f28968fe6bdb08"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2518e596d88676dadcfce5484d11b93694a47491c9a548f3843c7be1f2a459e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e88cf49bf8c058c430361b311b7f34f284038d4b0c798920038f07b2ba45f62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a188c91d7a308ede1c0f8698cb626be8bb45167983340406551078bef2ed8110"
    sha256 cellar: :any_skip_relocation, sonoma:        "90b7bf9d87628a7d2ec0c01a52d22d3a6285d5bc56113646dd468040feb61ec9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "725ca29cf882f32da532ab76dee90b5cbe1393f64b8a0dedadf771deb8f3f56c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "224f44fabe95a65238dc5fa2eb2d150f41eabcddf04ac04000617ea7046deaa3"
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