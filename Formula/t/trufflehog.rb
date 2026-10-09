class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.99.2.tar.gz"
  sha256 "acce1a028575040a7ff95456111fd5ea4c7c4282ac55705de10b7fa52c7a37b3"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "710bd58f2c4317c391db94dade70c74e9d8eef8e87af1cde5796698bf4b6a5c5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c5a5a97de58a62f6b573dbf9c100bfeb08886d351e1642672c1d9232b1c4e5c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "304e005077bda3e35bb793d23f5ee249d50ecfeebd443493403163c37c9c8ab7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e1f25dec073187e98513a629169da6fda7c7d8b3aa6605d6a95577e45b2c111c"
    sha256 cellar: :any,                 x86_64_linux:      "5e6b4c32eadb4c1401b93343173efe8fa957f0053b92703b26d677f723b120b9"
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