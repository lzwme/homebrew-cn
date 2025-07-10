class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "e00557ae5d441fc186134e6c531fc4af1cfb84f09c421ca0d37a98b5a60c0919"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7987fb551b5b8fc92433fd9d0d131939ffba8bc637bd93f134e9190cbb0c1c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0aa7063200f2446fbf711d4fb02f40e95e9e2b5db111fdd4959ca50de1da105c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72c2f752dbea296216ec5f2d7a869bfc7dc38232beff13ccf9645846b0e3e6bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "53eea63396c4d664aec857311017620245135ff6bf82e6ff7393b8fef0a247a9"
    sha256 cellar: :any_skip_relocation, ventura:       "b28fff593906673b32eb81450180344b0171fe99378ac46c6aa777519d320443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d1d70ef513e64d0444d3a96d7b7844fe3aea64d2d186b90095b4bcfb470ff80"
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