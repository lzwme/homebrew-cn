class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://ghfast.top/https://github.com/oasisprotocol/cli/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "6e8a3de59931ac81e6fc77cfc01553041b1b08e159a6d1547b6ffdcddcffb13a"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed77c8a7b8251541519fb70981b6f48305c9c6681bf064fe2a9dbbf10b178485"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e43e7bc979d22d67ccfad65a905ee8d31fb897f0e51e1ac29adf943313106558"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6cdc971d22cf1c3c357552c315ee00d0ec5bb1f2f0a43dc29065b52e57fc96e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "02f0cc113b4d7f4b05b6d574ba34166728e92736fc86fe17917fe10c96631ae5"
    sha256 cellar: :any_skip_relocation, ventura:       "f251488246f48baac3d7fca525bf9553a57db175541178dc81374d546fa96889"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ac7c3f1e92afec59d1482c00e52aca1c2cd32dd659cb80186a8cf5d6b3bace6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94210af3e16e15a7eea6e6157b86dae9f8dd4729cc0630ec7d006caecab97fc0"
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