class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://ghfast.top/https://github.com/oasisprotocol/cli/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "41dfff11de02ec339ca52d96d8ce0bbda98771dffbed8afa39e76334fd6d37a6"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aeacfa78bd69956c82c8a5c33b8e46a6d39c0f586ac3a7a84800b8a8f5f4e208"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3944c5ba6f7d0400e5b695ede142d1e6db2aaa90d0aa2167320d7d3127f83c0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa984381f25bdc2cc9e46f9760677f69e7e3d1b99495653d33b04b301d8cb149"
    sha256 cellar: :any_skip_relocation, sonoma:        "2576de13ca3675bd674fee110e3e133126fadd92eea94eb00601047c4bc4b644"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d8356639cc325dce55b1a104c083e28e2029d52d893f33a62f70db15641cb66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c20701e422b63a36f3dd3c99556015021d48dd41d704a3ead8ab57e1b57890e1"
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