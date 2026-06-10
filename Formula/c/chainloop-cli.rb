class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.100.0.tar.gz"
  sha256 "b0f838bb6a5e4401db5922dfde0c078509affc413772c990585033101b510bf5"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3a876fe6713c027c1885bd3090d541fc0d362606b52b3ac31f6f839a329a9cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22597e423ea8722014ae992fa47b810cfe07faa52e45a531033491d5a3799709"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a449873ff2c57aba5aa8be44446a220e744ce39034a5dbb32581f41dd072074"
    sha256 cellar: :any_skip_relocation, sonoma:        "74c695c4a490035f810786407b4b5a820c64fbaa45cf211a04d09e78ad8b600d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "236913efc2ee19c8dc528f447de057b3a089c25078d4f4cc2d6c0515aa00fdbb"
    sha256 cellar: :any,                 x86_64_linux:  "46ecd4ff36031def3a4ce0e0e913a4d2c1a0d1828527f9f8826af35781f212fe"
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