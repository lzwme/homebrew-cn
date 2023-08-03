class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.46.3.tar.gz"
  sha256 "803ec325f83756a36cd0f0449fb07b89e9d38904aa86f7375f347059e1fb3224"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/driftwood.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b3d08837412c714fd164ecd079bf05e9c1aa06e9897b45a083bc85ad3199025"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e30a3883acb22e51c5b57ac1125f8b11adbe3209483f71a555ab3d4aa5a8eb8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b09c06169dfef04a841e864e0ed7c31fda536e125c0d5dfee51dc1af6069b48"
    sha256 cellar: :any_skip_relocation, ventura:        "fb31c5835cbc27da62de750cacd7784e97290401a6eb303011f30133969ffb80"
    sha256 cellar: :any_skip_relocation, monterey:       "1f15adb848fdbd54771967dbe2eafda90a96dbf40868527327e03c52159ba71f"
    sha256 cellar: :any_skip_relocation, big_sur:        "09c96676f87eb358aa125da49537b495712bf2951c134653270cc3fdc00b0624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ff4723d0397e4f8565094ac2882595cddc08d7116c9cc5b20f615e3fa72056d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0}"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end