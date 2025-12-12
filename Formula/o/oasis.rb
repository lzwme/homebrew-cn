class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://ghfast.top/https://github.com/oasisprotocol/cli/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "d06509b746e314f5dd6969ad46b7f8985afc66c37a6d4fa3055c282ca441b013"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d925132a3f55900d41cd0706627d657bb32eea9bebfb7835838884e1bbc151a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93bc76b56da179893b78657daf9e6246dcdff3cced9908385635a79e869a6fca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc7c5d29532d1e7dfdf4da3af65d2c5915ecced098c3ecba9d35c2bd481da0e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec130a9a3eaeaebee0011a72f8a46a1fde10fd9625a4506e4e238e452922b72d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6568ab446b8c05c117759a2f758231b797b75113f6d71a782400ea7ead2abe49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af849e33e8dacde8b442ee2565b250e5e2893195a3f42d316213be57668283d3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/oasisprotocol/cli/version.Software=#{version}
      -X github.com/oasisprotocol/cli/cmd.DisableUpdateCmd=true
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oasis --version")
    assert_match "CLI for interacting with the Oasis network", shell_output("#{bin}/oasis --help")
    assert_match "Error: unknown command \"update\" for \"oasis\"", shell_output("#{bin}/oasis update 2>&1", 1)
    assert_match "Error: no address given and no wallet configured", shell_output("#{bin}/oasis account show 2>&1", 1)
  end
end