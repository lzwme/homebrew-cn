class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.63.2.tar.gz"
  sha256 "176e239402dd6c1f0ee09b0e765407ae646f4870e51c4ecb2fcdcd8aa2565b44"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4eb1451a4dadb7060d1371581a4eac3d1a9daedcbd46c86a19f5868b7ba5c068"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a6535b8197450d7abea53cc573eb375e03e0198a441d2ebc51de9be9f4a9c31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b42001f024322342dbe8489d5ac83e51d71bb247d625e367f8e8cb8fda77dda"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f18cff722b947276f5c60297655e4235a4ca76fa32c58f5d47c0e1ae960e816"
    sha256 cellar: :any_skip_relocation, ventura:        "ef08b8629cd94f5c779ce1f335fcd74a7eb70d8beaf319ac97e7139e59b08e37"
    sha256 cellar: :any_skip_relocation, monterey:       "3ce58193a19449522d73b965f15f104f89572569b225441b274b76c35ed44301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78ab85c608b37a413427da64fe560d39648be6fbb2a25ca361290d8ab46576fc"
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