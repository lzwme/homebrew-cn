class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.99.4.tar.gz"
  sha256 "2003b23e35751bed50bdd8fbef6ee9333c42145d489d97ecd7f14227f1de8b44"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d4e0bd9bf592e11ba01558726fff9dbf79395b4d3d26cfeada9d96a33e0debbf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "336ddb5912f19709c1bd4912cdc99f50d49974b3d4ce3990d4c5b4813b24bc6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "18de3641f6c3589d99a5045493a92cc35aeb2d4b6e944fe3e231cddecc3eaa28"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2311cb4dd8a81eae48513c7fca733a75913eb7597731b865311a162fd4442701"
    sha256 cellar: :any,                 x86_64_linux:      "060f3d9f7027da798e5d771619b9a47702616dd85f706bd06b28ad24915923ee"
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