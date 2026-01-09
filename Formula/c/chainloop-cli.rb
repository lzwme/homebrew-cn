class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.69.0.tar.gz"
  sha256 "1004ebd5a8b924b073be9cf386dca04488441aeac691dccef6bb4536e191101d"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d4ccfbc5313f9daa097b20904f9630cfc9e0dfcc65375c0f9183bf40e29acd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16d851b82d4e6e76b3d75537453645ee0efbf691e34c93cd51adec6dc340b4b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddd2e9a60cd81930de14ce4bda53da985a3c2e74b3df70db1724c9ff2f28690e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5fdfaf52bda66fd9eb2c6d6ccaa4ee0cedb1ec8b6b23b5deac80f9d7ab2a0b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ff85b422afe78f3992e8110c301c8f3d614ad6a3b6e7eb2f46386d02c6aaefe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f342e88bbcb1a59783f3c1451351019c430f25dc4e152f0009e60cbf1adf26e0"
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