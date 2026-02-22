class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.78.0.tar.gz"
  sha256 "f33681bf83fd01736f401c4c761943734df7111016d5f0ef6048d67c6c5987fb"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85f294133036d5f738d1d6abbbbb4df0d98c3c096e0e1d894b4de0c061867f87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "740bdd0c9092af08d42d68e927a8fd587e7253c56e203b6cbaf4fb46c7293080"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f2d52969990b4a2b16450768bbfbe69abbd2fae322e41e0c197509dd0c548be"
    sha256 cellar: :any_skip_relocation, sonoma:        "8eee70b2c17e9f687af1b06198c6fc09157e4a5214a955923525d3d84b973731"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be8e9ff4b3584fed46dad7cebd3d4b42554a9957e5e7b1f9c0ea9fe367ac6351"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6d74dc9ab580bbba73117df80e3d397fc62946377c2169b7821720505c998c2"
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