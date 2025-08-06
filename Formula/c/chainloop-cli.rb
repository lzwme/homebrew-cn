class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.38.2.tar.gz"
  sha256 "880f4983cafe85e3dfe4b017ff415e05dd2e7d665b3de6cb90ceb0011bd8f465"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f245a2ab7c9958d0af1eafbc89d1bc10c06bff07cc90645d3b2e4299d0dfb4d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae401b1f8ad20a5ce59b8fe3992cefeefa3f2536dfd1f6ad55193a968bd55578"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7be683d52e71c1e53803d9d5e2fe7c6afd618b71f3ed09c5ea2345eb9e4e73e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1384ff771b417706f147d02134b6685404e86cb498e88cc571a7d022543575de"
    sha256 cellar: :any_skip_relocation, ventura:       "52087c1c88fca6082c9c8ce55b562e4cfff48555697fa4ed117c0cac59d82068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a59b02950ba44d425ce24f2f2f18b44a0789bb9c6abe6a515e16dbb0b7b2d199"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end