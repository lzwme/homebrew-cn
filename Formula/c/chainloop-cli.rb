class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.87.0.tar.gz"
  sha256 "c66a5a2107e9c6d13d1759fa760a7dbd211ab85ec46f5d869d294dbb0f99111c"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61c33d21a8a566e3bed8387efb4f5eb8229982a947f4bb295b4a8e68b8480cf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "373aa52a7085dba3d03a81365c2423bd46abd40f91dbd5e4e4a233ef8caa6bb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4546c3c84498b4a64a87c462f169144e0aff38b6e3764809ae819134372bc643"
    sha256 cellar: :any_skip_relocation, sonoma:        "d609d4c466fafecc990f2c77d3a745c95273b549e521e7f0d0e4db9f32ad9c9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8466c5a750105525dc9b569597f39a72693c2ae126f826409dcb85039260f777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "855b635cd3847173663bdd138fbe42a95ce8ae9e50e9a12c54f49a5148f64b20"
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