class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://ghfast.top/https://github.com/oasisprotocol/cli/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "cf8745c1db11f4ce39f39481d71c0c9cc8aba7c97fa537f31947fb9beb68b443"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb2b27cab2c4c3ad2818cd58fd74d3da4123ce13518cbedd6e081f51e1a9c29c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d198501e9cfe6563dc5c917a7f444511ca71f574c6479aa0b5dfb4c872af50d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4305920acbf830411ab4c713b00f77b42688bdb16504e550359e35bcb2c44330"
    sha256 cellar: :any_skip_relocation, sonoma:        "8707d79fbcd2a951898e3433e672c7af0bb7d2430888f1492ecf6b525ae29ffa"
    sha256 cellar: :any_skip_relocation, ventura:       "a939282ee31567abd68f4b44efc5f0ce3fdeca07bf4c88f1c9de547b4f05e8da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82e5fa01776c794888e67ef5eb54869540995b048f9fced0696c948185db4a1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9227437f63370257264c060aa89790094c2f673e6f7e03d58807c19252fd5fda"
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