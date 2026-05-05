class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.95.2.tar.gz"
  sha256 "2f69c4404a8151d6b0b8696c8a384ced23dc7376919c38b11b857a110cf432a1"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31e23b6fd66049f6209472a698a75b370101947a18049b9b36f1fafab4a44a10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebc2ced82aa6f00372959e88bedd2c652e2812d5a4113ac0bb17460b782f895e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7512a0ecb936c0ef31029fb13f7a5bc528476965f56de9079fabfb143c63db49"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce0cdf278b61ad1b1816406350efa6ae75564d819d487b35f3d1de90c1dfb9a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8968eb79d71c09900c486f9e4d56dd186751029c91b160b4e2dbd9ebbdf99c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed413f2a63552286c276c35db8fd48f363a1e88f364ddefec12f8f35b1c9205e"
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