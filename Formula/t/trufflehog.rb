class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.97.9.tar.gz"
  sha256 "049c9af114596d49da08056c39c84cf49759da7d6b7806dab16e02f3b2af6201"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bb2fa1b54e3106d182c9bd13301830ecc23014d770bb6f9d60be64a0cfda24d4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "343c6065e5c8b826b86095a8f5b5e2fa56755dd21447bbc4c8991ae116e0faf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fd63c8da09e8f0f4d63b3b0788cb1cedac12e04fe203caef64ea517c110a1a48"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "97970f0b1a71e4a5489b91d97aee7ef0a25f85e349b37ae7f9119b544261ff74"
    sha256 cellar: :any,                 x86_64_linux:      "5cb8a7b59a49ff6727b5ed61e393b70b274b8f8933395195a8d82df5c9448b0d"
  end

  depends_on "go" => :build

  # `test do` block scans a GitHub repository
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "docs/man/trufflehog.1"
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end