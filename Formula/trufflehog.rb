class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.48.0.tar.gz"
  sha256 "811ce05236cc6053a5f7347e71e9f2149b6d4bc8325d1b4b6068cfcf220b2671"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/driftwood.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7923303fce233387ed55f76953aba0bd17e7a40740cc1147e4c44cab9cdbd89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5760197d30192a206b05ffa5b3ac73373a86df7bea0a8290603a026af011daa0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b4cc050a5bfbfe872ed485effb97fd3f235760b944b84e1d09e5647f5a82b54"
    sha256 cellar: :any_skip_relocation, ventura:        "a30eca41531d72f848d96992742aa4e638641474b1c796e237ea483c4a457f2a"
    sha256 cellar: :any_skip_relocation, monterey:       "584387ea823b3ee9284ce1f3a53ef42bd0735897ccca85bbde5ba54cef2782bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad0020bdb68cc56fddcc749c205bc6eae4c98f516984add19112d126279c34ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b378fb5fb3c625919978b9b9ede1b40221d96430072335e6cf68aac683329d83"
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