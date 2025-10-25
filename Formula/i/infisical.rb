class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.17.tar.gz"
  sha256 "5a5b8758dfb2a1773815463c5c028d3e8a81430e9e78ae47bd9134208a89f2a8"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7171fcc5d0b853e48a17f5e27e58f6332c56671a48b35d913f1eed9189942950"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7171fcc5d0b853e48a17f5e27e58f6332c56671a48b35d913f1eed9189942950"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7171fcc5d0b853e48a17f5e27e58f6332c56671a48b35d913f1eed9189942950"
    sha256 cellar: :any_skip_relocation, sonoma:        "de6ffd3cef99e5fb186fb2160cf136d21dfef53089d0962013de782137eb7288"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75ce28128ab7053173bc5fed096ba37e26262efaa567acd85d4913303fc4d7f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36b32faf64c221994c4553dd5bc79fb2294bb819dc80f94e12a0155f37aaec33"
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