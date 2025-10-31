class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.21.tar.gz"
  sha256 "697943ef22631234c8a4fe17c8709f3d84498bc443317107ef5025597950cb8e"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19c556d924064495cb55449ed2134050d1134ced031dc9269ba0951a9e078d21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19c556d924064495cb55449ed2134050d1134ced031dc9269ba0951a9e078d21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19c556d924064495cb55449ed2134050d1134ced031dc9269ba0951a9e078d21"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9c949155771e03128032aac73c9c3ff994ca231112a5ea0ddda044c43c52d93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a10021a18cca469a46b0fe40978bb8aa332259caab9c04bd635c0f700381663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a8a60e3468f72c14d921c36ac9452378a6ce5ea622d423c64ad953e38355f2c"
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