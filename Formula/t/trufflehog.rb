class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.94.2.tar.gz"
  sha256 "7e8c6beb08501c6933e21b5b2c39c94c909b7e344a3eb0bd550bcd5444a202ba"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf7a6cbf67c103de6126f7c8b44605f731b9a80892f720a96f1682b9f8540b3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f9b352edd6e212ca37c70c11ff4d2d216d7bff03b184cc6c901c6d37a4940a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e705463b903c294955a89ba44943c55d6211ebf5875a4f5ba7961a63e3222bd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "91a1ff963f21bda5b535961646621201528215fd86c96763d9bedb6c16c3abb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de31863f3b4b3a86e4a7dbd13190db5c015dca00d91d50b39151625b5a67d8b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6ab9d251c9a5689690fcca444b61c713dda1ebfea9e76e97152db45d2987bca"
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