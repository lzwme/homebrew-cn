class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.120.0.tar.gz"
  sha256 "bb14b9cd7a49fe3ecc59131d704cc28cfcdf92f6ffa6cd66bf893b47e8ad62bc"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d354ffea4c0282e53f491383975f19bf2f251f9e7b51bffde6a321bb66917cb6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d354ffea4c0282e53f491383975f19bf2f251f9e7b51bffde6a321bb66917cb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d354ffea4c0282e53f491383975f19bf2f251f9e7b51bffde6a321bb66917cb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "379ac9b9696babb2b27c3b87e52b4643531e3777a556f9a9f791b2aeba8dd280"
    sha256 cellar: :any,                 x86_64_linux:      "926f2afeb7305d153386abe2fcef1e2074b38d124fae0b4a31bbda71d01bc616"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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