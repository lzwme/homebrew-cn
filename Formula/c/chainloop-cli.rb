class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.100.6.tar.gz"
  sha256 "856597f78d4343e1f4f178260afd7be54de81f31687033217a7729df7252bb04"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "726bd275a2c6b82a8811f4ab86859b38aedfbce08b7fd509b8f09c32dcf68fb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "726bd275a2c6b82a8811f4ab86859b38aedfbce08b7fd509b8f09c32dcf68fb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "726bd275a2c6b82a8811f4ab86859b38aedfbce08b7fd509b8f09c32dcf68fb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2525dd38e5a24af7a07172aba0c90b0cfd64cee6cd32d14cc0ba5b3b14da7811"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1800cecebacdd6e2e312a1a33c4b6609139f2159e8713c8dc7166371fbf0088d"
    sha256 cellar: :any,                 x86_64_linux:  "1bd590ebfb66bb9276b4eba7addd743818857b60fab205ae7ab1a47d5f8f75ed"
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