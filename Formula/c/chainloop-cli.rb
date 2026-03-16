class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.82.1.tar.gz"
  sha256 "984ab0b14fd7d7a9ca1dac4be164cd62e3e5320fa5f238b34a53e2ae9eeb5746"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45322eaead533d50974acbceb446524c09c1b8394224e730d6ad0ac26f26f63e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22dc2c1e3cbecce7d82f7c24f3a3716a8140c66af5b20801397064cbea7d3475"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d36dc08d799530734a3e847fd196377e2d0e82351a3ea6479d03ecc9af24a71e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d4897d981b4ec5c4fd13958383445702af3b661c8f0d114b72f8f5bc474b656"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "141fae8690fcc93b51a79ccb24fee46085ba4c8cfadf8f006c35666c4ec4024a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c8024daaac8d27976d6a5101d1fad32b12fea030f0cf2447ee598d6d10685f4"
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