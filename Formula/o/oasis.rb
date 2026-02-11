class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://ghfast.top/https://github.com/oasisprotocol/cli/archive/refs/tags/v0.18.4.tar.gz"
  sha256 "5f0de8c075cdc475dda9886a12514c7a58f414d96041ddaeb8c5004ce9c5a384"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf4123f98377ed5c86ee72fa5508dcaf5b8ce8861a2a3406a5ff694ec769e0da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bdb1f0faea677bc0cfeb6c5ee01aa6f39e5379767d0b8ca76061865d9f036cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdaf57d460800be3adb5fb610080b6c4636a4b0a19edd579fe3ec32e4d02f5b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f03e9262447138fc2b661e761b3b9fd48f3b6c997ea7883523d88a3649a3ae04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3acc178c6e1c50083b06960d8026c77e7068b9715d91d307bf6f10fee57f8d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06bf49a94dc812e7d583cff088d369d54a2c291cb0f319657c0b8ed17fb69384"
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