class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.35.tar.gz"
  sha256 "4f5430d9c6a103b5f08ee941dbe95f2c41ca03b9c17b1c6ccb5a34769ad50ce0"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "882eb80258cc745562bc46cc0c51b393142b5e99595b4fb6e907b0c6b98aaeaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "882eb80258cc745562bc46cc0c51b393142b5e99595b4fb6e907b0c6b98aaeaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "882eb80258cc745562bc46cc0c51b393142b5e99595b4fb6e907b0c6b98aaeaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "049559bbec4e4aef91baaa3489a219a0ac43f3d319fe6dc57db4b7f1e0d9a5fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c62a543f630ec35ba1718ccfee7f23a0ac5c1fff26f4e32846dd451befff3f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c505b98ed8242a803992dae74e7d63e91739a06dcac7210089f438fe17bb3ec3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end