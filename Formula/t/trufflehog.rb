class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.96.0.tar.gz"
  sha256 "f5b01224d4f43a5b3e5614d1fb3d53b3286fe5481b076bb059c42db0dec5adf8"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8366ccdc64485ac4015c5ccc3037467c5d10b9490c21f84d660a12fe93fd80a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfa0e1af9a80bd2714b45d07d7c568f3f59d9f38c9ea734f8ebb01f54ec1221e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69604e263535e5e5ff11dfb2bb5292f46019300674a3b45c71e56e3ad07b0158"
    sha256 cellar: :any_skip_relocation, sonoma:        "826a8d594edce05765312b8ee945a8e1fdcd018fd915fb9f203b7866be7b81ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5136148379628a548985ce8c9b6097adbd5debec24ef28125be117392593a79e"
    sha256 cellar: :any,                 x86_64_linux:  "e3317c7258b4bc1e148b2a3deadc59277a57acf9abe664fa3bfae2529a523200"
  end

  depends_on "go" => :build

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