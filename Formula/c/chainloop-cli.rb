class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.104.3.tar.gz"
  sha256 "d63fb6069446671eb7f4bd190ade1916642a9f3f1c23f3b61e249bce2ea6b807"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c6e53fe00050eaaef20f3fe109c0e970c4e874db8b0b5f29aee8517bc268474"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c6e53fe00050eaaef20f3fe109c0e970c4e874db8b0b5f29aee8517bc268474"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c6e53fe00050eaaef20f3fe109c0e970c4e874db8b0b5f29aee8517bc268474"
    sha256 cellar: :any_skip_relocation, sonoma:        "f49a2cab94c13313b68e3a977a93f447b07c006d5a5e1a3af3ab0eb29b0ff3f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff5c18204db6c03cc890b5e60931ed990d7d29e1ef4f9e97464ba825ce7d5a4e"
    sha256 cellar: :any,                 x86_64_linux:  "200f383d04d96cdb98e4ae21e01541b15c2877877b39763a33699c76b32ace41"
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