class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.22.tar.gz"
  sha256 "e1286817c2f1d180d6213af1c1c1614c3614ccdea346f3729703f8da43234aab"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a799200c9edfcd2e491758f5e36befe803bf0ade8256d25fcbd22fc3846e837"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a799200c9edfcd2e491758f5e36befe803bf0ade8256d25fcbd22fc3846e837"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a799200c9edfcd2e491758f5e36befe803bf0ade8256d25fcbd22fc3846e837"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6b5edeea8d92fe76f20f9d2b8dddf59ba4620ec8c7de28dbe051d0566eadca9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ecd6a794e5ba7271f6650ba98c36655b824ce8b42dc73d7a4b3a5a630cce771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87de0467b1ca4faa42907d445c930b7162b70ac737dbd53f926f1aa7a3353462"
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