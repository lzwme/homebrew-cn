class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.20.tar.gz"
  sha256 "a80374490c02c8849fb4efef06b9b9660dfb17d1ebee1ec4a1a1c1829ebe505d"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6799ba27bc7289200177bf91212c3516108df3d482314e9ab20179128f2adb9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6799ba27bc7289200177bf91212c3516108df3d482314e9ab20179128f2adb9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6799ba27bc7289200177bf91212c3516108df3d482314e9ab20179128f2adb9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "13ecae6ad1dded20cd9f6f4792fdd62a00e23aa93f11b5e3ecf99f0dfaf0571c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e08c9777333f386f9b9cf39553f87e97b277866660b34907ee1a11b282536bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f48a75cf327e2c0425c0c203df5d75a9dfcbf59d34859abba805c0f55e61bcab"
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