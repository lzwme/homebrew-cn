class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.81.2.tar.gz"
  sha256 "c5bc4c34f10d37c04309d27eb8facd5bb9f2d64d273cc15a86de7489672135e3"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be2ac033c683ad1a3f35604202fa27cc46e632a4839666713612c3d1a9aa7deb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6353940ce5252373d7d3f62960807087b010fffe0960a04fc74cf527fe14da7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce1a299340a0b671d8b729f48955f45aafd261f75beb13e163c1151b465ccc81"
    sha256 cellar: :any_skip_relocation, sonoma:        "a81a1a72a83b9531cfa5606c2f21063f1307b3c9a8489af3181e4b92bcede08e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48db32384227bfb7b902edae6ad3e64f4bc680f0d5e3578f9d13ec23775a2aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68398aa0f8ca1d6acd34038019d9d52bbfa22086f141bbd2c1a519107f3ec4f8"
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