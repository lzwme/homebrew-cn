class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.92.3.tar.gz"
  sha256 "0df44cb3e61cc876be411506d506dcf975c9b5314741fa7fb3b6c34e42c64183"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1efc7236e709e0ff298f2cdc49c2adf62dd6fcbcf3a50802104e2f74253155dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0251c1d806a18abb6dc63729fbfbb05f605e43ffbbf636551b70673d6befc721"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eecb90c335bb46e288b27a9680ebc614eb7979f8733e5c4e5eea66083e759ec9"
    sha256 cellar: :any_skip_relocation, sonoma:        "583e5cf24c9a0b35e8cccd3192348ff7385cfe21e51bea18b1f2b02860e76b0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "824ff8d3bd0417cb41d6a57c579be064aea5cfcf281bf6e0677259199c30e7b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e93272374f01ec2f2cd07f5d72651ed6abfc4f3e938089810bcb95fe6c3bf0f"
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