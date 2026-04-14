class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.91.0.tar.gz"
  sha256 "e4f86f36e41ede364500a6d5f3524b48e2d90813970d328283524d2ee80eb5c8"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b75866dc6704e2ce7e9c43fd335a1105fb14778472be7c09c3fb23e7f5ea66af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b504d4116297c5d476147132593148fa5837b1e015a7eab5c37124e1b6eebe3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b97ccf6cadbc6f3623635ee8b4f5cb99aa1cf12c0ea31802d4cbd39b16ae605"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c41ca02debaeb2e70d184339dc7e26963aa09ed1558976e103b2ea1d1abae7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3a94abf0c7811806c507830dd4902a655e3c07095a4eb0d4b2db5e684ec9260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4d0ea0404f73c0f9371c1a7e8b3a5e7af4a6d28e842a2c085fcaabfcc44e918"
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