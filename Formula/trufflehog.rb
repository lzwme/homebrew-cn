class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.45.2.tar.gz"
  sha256 "55a7d915a6439f86a3b7a3c7f365a11468df6dd4bac31062241ccf3eec54a27f"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/driftwood.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9e04d2cdc6da5e37ee027bed53d81d2cec4ac06697964874b45ebac354bb643"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3909bbcb4b80759d9e9488712d383966dd343eddda91fba6d6fbb956451bd7b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fac1f1dd2a0db170e2b46fa2fa1d6722a8c9f2a7da1c2c417240a2804323881a"
    sha256 cellar: :any_skip_relocation, ventura:        "42338660d8b0062aeae2b0e9d3711e2a6a6431101ad8473e2acebf8ae743d1cf"
    sha256 cellar: :any_skip_relocation, monterey:       "edf81fd57b6851c56ed6d79f267add3f15bd9042f4cfc0e0e2157a914c37f810"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0507760b158e5409ef0dcdb4eb2e42b075826f34c7b43cdaee27bd9e8d0d292"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d278874572b5010b33d27c7f78ce8b75151d317893d0ce5d6d5de6ab52576068"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    assert_match "loaded decoders	{\"count\": 3}", output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end