class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.16.tar.gz"
  sha256 "5093c60848cc6f7d5e8f68972b81f8cb366d5acf9ad7179831166423c3b03b72"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdd0f3fa365f0bdccd76c8a2f21f7afe795a0ffe53fdb064e462917fed5d9371"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdd0f3fa365f0bdccd76c8a2f21f7afe795a0ffe53fdb064e462917fed5d9371"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdd0f3fa365f0bdccd76c8a2f21f7afe795a0ffe53fdb064e462917fed5d9371"
    sha256 cellar: :any_skip_relocation, sonoma:        "1227d54ca7b871f9bcb4f0835db568e2401215d11c6a4d37bf8c3e570c841786"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d162ecf2c7854906e5b81b9da50c83a05a92f7398cc9e3267dd1ea7788d2db3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a04d8fc5606a216e3410e03ac042a05a21f749ddf71eaa81cbcad2a5d222aaac"
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