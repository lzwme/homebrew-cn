class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.55.1.tar.gz"
  sha256 "89bc22bdeb000919fe7dbea1ba8697529c2c0a4d01fccaee4214e08eef60460a"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d60c6c37bb80f3c0a3d787658329d96388cfedd90cddcc4f77c4cc60f60d2edb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a00ddb59a403a3f4801d36199dd7370bcbcb47fd58eb579dfe8a7ee6a0a47e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56399840a10b2bbccc3534b2d72ea0aa5b1f561774a22fcb8af46a980902033b"
    sha256 cellar: :any_skip_relocation, ventura:        "46e0e41957464cdc2d8228cc853c9b8c4d2eb5bd6df2aba136a9134e7a9a053b"
    sha256 cellar: :any_skip_relocation, monterey:       "8188a2b483481588b21ef3bc2efdb2b14df18eb8196ffe3bf3821b8f1ee0154f"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb92122c2f0b83fa5b1e525b17e16fd7185fb5bf8b4d2232940f6318dd886d2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b85acb15b61aa19e1857011083dd20274f9d13d64ebef2c2042aa0c9badaf155"
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