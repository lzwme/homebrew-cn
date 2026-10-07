class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.99.0.tar.gz"
  sha256 "e93ec9c97417bae984e5c751480904ddd928ed78fe5f1b18e74a11fc265ae474"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "825da52c91361e21d25eb2e136f4724d5f06e3ef8f013a09bb92decbb483366c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "484ec088393a225b4bd292c6a2ef05da4090f85a469feac4baf2a0d525b677f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "47d04651e77907518a8b3e508ffbefc5bce133a4679e0f1816495a2899179955"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f395a03f78f25d2486c0c97856c98a17111973f2048dc62c23c3feecc67c5ac2"
    sha256 cellar: :any,                 x86_64_linux:      "39d11f665cbab137057c4468060c8ad4e6d1a3871f49322e44d30e841d7f553d"
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