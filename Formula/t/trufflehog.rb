class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.93.1.tar.gz"
  sha256 "2cb36d5ac0405141ae14cd1b604e0ee52d50134304f812e8c5926b3da2e2b115"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39d569e5480325d0f133a71c164aa4811e5fa9473b37e21c0a8403abdad5ceff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1e8d2057e76ee89062eb9ca26c590709b10fe19e8b30934e90e2f619c46297e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c605357adeb3c84ef7d3882252d25e6f2e60b1b3a6cbca3afb8ec5d6dcfb62e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f71aad37563f19e65a99e7fecea5fcaae606aa9ad111172d72293a99356fd37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8b423e79856b711e82d5a5613d3c3d70c933055839607ab6031a307e38ca8b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d49d9420ddb5a66c6f319c795a7ee1a7230a9fd680967521756ed40290bc902b"
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