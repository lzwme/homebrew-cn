class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.90.13.tar.gz"
  sha256 "e0a206f234eebe567a2b953fcdb089c9a1f7045ae2a9ca47b7c5c24fe4999e89"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55bbb4f7e6454768cbae74bb0b1e0c0efaac1aea146cf8d5532fca912d5f8fb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "991462669c51e0424f780759ca4950d68a29dd2c92e338735fcea6193037390e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15d2097e44497ceb7b1b4957bc7099c6888790291c2b0f5bf5db168ca9aa7947"
    sha256 cellar: :any_skip_relocation, sonoma:        "27f8a852db61a3a2714011212d301ff1d0229226c4088d02cae4774e62f2fe89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b23f591af4b4fea1dbac3a74861b0c8e3fa656415d006f5c4c4b1e190f8c3dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6e6074ec3ae558e574952d1c6817d492067ffec1efa3b7b32092ed9b2de19a9"
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