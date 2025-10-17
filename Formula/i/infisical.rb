class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.10.tar.gz"
  sha256 "80de97ae14e8a441547c900071c1bc0406c86cdf0bcda325fc6c863d3a4e27d4"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56795310bcc8f70e66efe2810c473e9656913e5ecef2a512b265c4b63e91da75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56795310bcc8f70e66efe2810c473e9656913e5ecef2a512b265c4b63e91da75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56795310bcc8f70e66efe2810c473e9656913e5ecef2a512b265c4b63e91da75"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0b807aeb32dbcf4b7e8373ab2c462af59f441df79b372e01eb7d0899a6061f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5e028d6c7d530a4181f9927e519a376c68a86bb07fd725236cc9dffc3f64a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9233d5aaafe1f2ec8da26c071e65b673bdcb8f05ae5ae5dfe8c734688c3f9f38"
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