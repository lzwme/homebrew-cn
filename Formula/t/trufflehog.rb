class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.60.1.tar.gz"
  sha256 "703f4556e483e2dbc6ed57347ea3ee09552d76ef46dd60ca837627167544ea6e"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd9d04c6fd0c2bd55d387d3f5900f94959c1627fe2322e64cd618e28fb264495"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c11d5a7c07543ea6ecd7ea728a15b4add01d593bebedf2bdb1950d8500351d90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73db9d365736489ad55a2a61b962c3858b0e9132918b0b4b69d4f4487710925b"
    sha256 cellar: :any_skip_relocation, sonoma:         "5450e52a87bce41e877cc4dbb8509a7f8bc138da4d62b26899c69b7401a0cafc"
    sha256 cellar: :any_skip_relocation, ventura:        "ef5cb2871bdb6a6beeeaa56bbd1fb3d62a4d25db27895bc59b4480c98f598f02"
    sha256 cellar: :any_skip_relocation, monterey:       "7830a499d9fccf1e7324db8b8745e2427000cd4416e72df43f14b17e60534030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca863502b7d2b472a565436faef254f76fc631ad738fa422c85d9d129bc10389"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end