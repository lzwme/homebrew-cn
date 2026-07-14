class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.104.0.tar.gz"
  sha256 "2ea202ea02cd033156755f32e06ad17aabe500de0c94a82803ece52e8343f7bb"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f146864cc06a4323e747527dcc61505957bd957d8a02add26b3028fba6a980f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f146864cc06a4323e747527dcc61505957bd957d8a02add26b3028fba6a980f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f146864cc06a4323e747527dcc61505957bd957d8a02add26b3028fba6a980f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a49a4e8a8e475b3a0ea8c9a932356012b4bdcf9d23b7693195ca9c22d5ffb45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85c901123e050ac3d7552b920e2919ccadb1382af8cae1749f3d55bb8d6bf4ef"
    sha256 cellar: :any,                 x86_64_linux:  "032c1ac69012fb9ac45581aa33304f096a4e5389d71e6eb5bbf2bcd3aba56959"
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