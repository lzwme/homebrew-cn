class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.28.tar.gz"
  sha256 "407f46486ff558f3f2c7a391ede16e31e6d3899462d5fae09fe00791b8de4556"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c30f37f762227fcd2a6d5f449b89d4562e3c6976fe8cac159ef19ead35ff77c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c30f37f762227fcd2a6d5f449b89d4562e3c6976fe8cac159ef19ead35ff77c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c30f37f762227fcd2a6d5f449b89d4562e3c6976fe8cac159ef19ead35ff77c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a0ea40d2e8fbbcd5f155bffe8a54cf3cc4fa5eee670cfb316373e71a23a77f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c85e97bc4e093536b76bcefb334352abfc0db727db859e6f4b5fcff3914168a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d8b20929fa24393bb6650bfc1842a54adb8cd857a24a49ce5b9a333bf2be2a1"
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