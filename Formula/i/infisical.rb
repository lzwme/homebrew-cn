class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "98e52441638f0fb170996e939b73faf522ebf0ca9d9defd35c67e9ae7f84518c"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "843596a54cd53bb2a8cdaabe6ad7dc7c271fd3b5ee990f74055dd20d74666bb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "843596a54cd53bb2a8cdaabe6ad7dc7c271fd3b5ee990f74055dd20d74666bb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "843596a54cd53bb2a8cdaabe6ad7dc7c271fd3b5ee990f74055dd20d74666bb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "82e4750e2a2711ac692f36c4c8d7074f93b575e6fb43e578ce1b1f7c6c91cc24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "839dfb478c1529e4b578eebdec182698188213ba2d0076b272fdf4925c08577d"
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