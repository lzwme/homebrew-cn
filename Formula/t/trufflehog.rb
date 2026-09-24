class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.97.8.tar.gz"
  sha256 "b364efe0322e3d7b522771dcdfb4b0ebbac8382a7488ee997ef0c12c300e5465"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ec78f99d25ce9af9323c95c256cc871213e031e7dd78c6491fa2bf305b328ad7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7d363d5024ff76afd2ee8bf89022bb64529f22bd2ed09e9f97f0c4b3d6e4597f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b040a24efc68d32e504a00661491335b8c5c3a89c5c8b3137057671ace86ba4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a28bd6a59c2c9e22f2ed0d75147f3907f8abf0dd8cd38a91e6cfc326bea5a09f"
    sha256 cellar: :any,                 x86_64_linux:      "4305da14bcd06d19235898e6e29e976f9fdce9c5894c629f74e0af541047fa34"
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