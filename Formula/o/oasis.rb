class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://ghfast.top/https://github.com/oasisprotocol/cli/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "0ad2accbff7d7c98cee492653089490bc077cfa0229e8052d8f6588a82af2f1b"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "badc4c49cff7f274cddf7b1dea652ada9ac1241e927ea3dec5307065a65a653e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98b6c80f9ecf2cdf146644de1344cd87452feb7c835fa99dfa093edc29c08b07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcda1ccc7afff4156c6b38b3385f58266b920f5cebddcd991260a13079313881"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b557e4e4ba687051060359bff4b994918335d0000394d491d0de09da3f02860"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "765a9dc1dede571b46f7d9a3b9e3ca43d82d318e4f4729f938d53b53bf69da15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "265d7d37efc54a63efdb37932733c76e7bcb678b08835d7da752187f07171c70"
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