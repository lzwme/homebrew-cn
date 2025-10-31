class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://ghfast.top/https://github.com/oasisprotocol/cli/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "b0f92527b5dd1e5d9ccf08300760de51441b36067e4c164bb2cf6ff30178641f"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4ba0cd7e47453e89f60a82f8caf725a5f3f57c5274161af23f911f407a349db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93a69b8154344d00a76fcad886338536d3ae9904087a50697b1167b25fe4a794"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39a5b6f44d3e91bbaf6a57af7295ed1bdaa3da125f2f569ddf1d86df28824c82"
    sha256 cellar: :any_skip_relocation, sonoma:        "22e0f7ac55b046b04bcd513a81043e016ce11d21a6d79a10e8ab8df56c5bfba0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5888b259e68dfaccbbcdd3795638166653d876ab2d5299b5823126f0589b62c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61fb2b3e01ae1c26c6e066f4703fe5fc83cd5f7115b4def63bcf6cda69fc9b63"
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