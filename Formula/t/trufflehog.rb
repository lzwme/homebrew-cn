class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.94.1.tar.gz"
  sha256 "22b4e7f05de766f21267cc2dfc65162ae56778e04bba925ba67aa790a2963f92"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6aaacf1d20578faa2fe41fb1e4dfdd5e7feb1ca8bcb487042e5e366dd3968d79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e54e88081aa2a19ef9fe10a461d01bda10d123719070153dd0ac372d3053b3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad87d8b3c916a7660b299568c1b3f0ec40b9a2d8223835e4384a3fcd98a90724"
    sha256 cellar: :any_skip_relocation, sonoma:        "5752eb9edd92fcbc88e309b9987e2efc763433761171823adbc7ac432f42fcc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2e728c1e0c6adcfd8e257382bc46f279d6a1a72ca47a6cd8d392f5292c63d0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b0822a853ea4b24c367469e46a69c59952665cc75a8b5a3705d32cf525dcbf8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end