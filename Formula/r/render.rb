class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://ghfast.top/https://github.com/render-oss/cli/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "8ae33c99d8e2621f7ba18612b582f883fd93b2c7f9b5a916c214b25f4f1db810"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "559a0d58d3dff03dac51a2221d52cb2979b7583727743659bb4a090312ebb487"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "559a0d58d3dff03dac51a2221d52cb2979b7583727743659bb4a090312ebb487"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "559a0d58d3dff03dac51a2221d52cb2979b7583727743659bb4a090312ebb487"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f2011fccea072336a0a24f07c2b0f4972291fc7611c7e09cd6833a3c9a5b205"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46ee730c063f52cbda5a1d227577129323a9f074eecb51a69899b7e730d28306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d314f7255401ed5c8752605d61015334fe055850fa9cbb5107c8ada59cda6aee"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/render-oss/cli/pkg/cfg.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/render --version")

    output = shell_output("#{bin}/render services -o json 2>&1", 1)
    assert_match "Error: no workspace set. Use `render workspace set` to set a workspace", output
  end
end