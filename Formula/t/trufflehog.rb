class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.90.12.tar.gz"
  sha256 "df98f2d3cda1f6d4556a82732004943b8eb7e8c0a057a7d9f3c19c16840e35fa"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9fce7801bc5e305e9afd79f3faa4aa26180900670e7f63cdf5054a10ddd7474"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bd429959ec23b4347a1c4faa637dd4990331c61d173845cf19f5fae30a74ba1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "853d6b49076a9b39bd09a1ee0aa4ef95912bdfa8d74f170c9819def1e332eba0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e108f7c1f39b4391536ca767d89c282121a28d48c0ccd1cae12ec0649c8ef3c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8cfcc81f7b94b5b27cfb16e6b18bd0879fd4675fdd8bfe3a2657d07e8adce14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef3a8ae845769dd5a8482e2d550da17fe02636a197e80902d9fb057793a91a03"
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