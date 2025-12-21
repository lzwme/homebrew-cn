class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.46.tar.gz"
  sha256 "808b70a3c7b2c6dff62df3e7db5953a348d8e2e6d8c8452a25a54077a1bb7517"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd74ae4277be1400283daaaeb5c4fdf88efc3912d5f449f5e87d2b720440dd5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd74ae4277be1400283daaaeb5c4fdf88efc3912d5f449f5e87d2b720440dd5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd74ae4277be1400283daaaeb5c4fdf88efc3912d5f449f5e87d2b720440dd5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6398b0454ea0c0b4520351b81a0e73baefd1f520597cb761f25bec6e48be3363"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2d4249cb4f53a725f7e508021e8e47ea25a1830c1808c7f6738d92ae17ad718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7034d542daf543af0c16f847d8a5ecb0ec54706834a2427297ba4e35f13de131"
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