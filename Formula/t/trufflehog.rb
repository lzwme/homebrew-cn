class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.56.1.tar.gz"
  sha256 "9b53807df72646e0c6b96af2a3de4ff5c1b1eedfd04efbdf124154ce4d4ae5e1"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e24a72212a8afea5363be55745a46f581de2410d35c03fe839ff4e39c61a758"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e341b16b1b5690885087676875a6f2d4d151892a070329f8f76e3d6b6117803"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e8f9b032bbc24580ce5312622f4d0482195a49c4afeb6f07dd50a27f50c3d0e"
    sha256 cellar: :any_skip_relocation, ventura:        "5183640aea5c46a39f34dac06382ed65e34e58e3c21be7ac39e3ab8a400cd9ef"
    sha256 cellar: :any_skip_relocation, monterey:       "99a0d6519a253e422b20a787b09ae71a6e5ca3a423e40b6c16ed0e4c05a0a8be"
    sha256 cellar: :any_skip_relocation, big_sur:        "793f48c3fe11c178c252d1d71fd1cea2c71331f983f016564772952b6bcd632d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7e6f1a40cdbb6c3cbf6a09bfb99a93d96b989c09151478e1f47a1e3b182a613"
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