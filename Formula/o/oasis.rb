class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://ghfast.top/https://github.com/oasisprotocol/cli/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "906723ac1d2cf1ffc07397c6e10d456325368ac61fb5dace799a68b3652de11a"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24419dd96442218156b95b5e7cf11e678270e26410d496b17c96fb5560a775c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3a2cb3e4d58e4185343f7e216e06fa9a14427c16ed705058e3d6999f46a3e8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb9765d3b01019bb76a3c5b59a5761fe1869c614a094d6a1a50f90e036d9dbf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b0e078b4f2ac9b106185ecf61f228130e0059108b01a7b5148d6651c709522c"
    sha256 cellar: :any_skip_relocation, ventura:       "38c4413ed90d04fa42229957e9aeff33aded0d78dc347174c00ef5ee50db5f76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f3c87d5a4ea5128a47d7d2338f50050fbcad49bcc95f8ec99daad32409d01e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08ef3e47a5290d3017dee9d38485e5ab0cea6d6c27e6518f33b3431970b92be3"
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