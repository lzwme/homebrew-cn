class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.6.tar.gz"
  sha256 "61102add2333c682f83d239e749cf7d6eb3344fc15b507117137121187dbe0ce"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd4e5cf3f12765845ced4b0b245cf254027c22750a73d38ce453fe8c7ad99509"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd4e5cf3f12765845ced4b0b245cf254027c22750a73d38ce453fe8c7ad99509"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd4e5cf3f12765845ced4b0b245cf254027c22750a73d38ce453fe8c7ad99509"
    sha256 cellar: :any_skip_relocation, sonoma:        "3359d49627de62857b280c9d68aa0aa25c9c8412c69bbb76fe0790d548cac4c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c39528d5f7b51ff5cc67eeadb8c1554f3ef4452fba7bf73d7ab16eb3011d6258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18d70e7b5da5f1adf7fc22d26d24cbb0f68a52123b62e92a480b1048d69a5d94"
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