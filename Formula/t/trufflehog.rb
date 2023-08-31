class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.54.1.tar.gz"
  sha256 "3257f102424c4538d7c3ec396dabdd1b8ee6718903b966c46b4b523d7b8ecdd9"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/driftwood.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e8112f883bfdd48d0d3cd5bc1bffdacafc4fe140c94989f3933d4178e128dba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c8f77044c0c3d0269bb2e4355ee672eab324e96e49872b2e90bd3077c84532e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd02f82e6a83d9046a85c5ed853a4fba77efc0ec3e5f159f3cea27a8b1ec6e55"
    sha256 cellar: :any_skip_relocation, ventura:        "ade47394f43f9b5c4d52a11ab6d8a6539de3f4982e21496c18f40b7b5ba2aa26"
    sha256 cellar: :any_skip_relocation, monterey:       "d1c00d371096822b049ac4033565c6d99a2e2cd6ddd8e7d9c990825c0d711df0"
    sha256 cellar: :any_skip_relocation, big_sur:        "57e8a2e749e71bfd5a204da7282e66f286657450930ec176736da38dbf095302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "959c7a61a78def885b67b2a5ec80d0bfd17851fd0d8e13b4e179534d13e433ef"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end