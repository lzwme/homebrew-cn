class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.60.4.tar.gz"
  sha256 "1789f8b0f58b5397d177cbad6a8d483d9de121fce7e1817994dc01327b8556d1"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "421c74b43f4ad562b76d844954428a885cd457c39ca449c80c10476c3533c66a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f373e62eb75fb26fe2abdb21f281dc7a28715bf838da8b4a7e702a3d408bb8f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1642091d8f51be189892cf606670788ee74c68d09ac0b0cd65d0ca12d291fecb"
    sha256 cellar: :any_skip_relocation, sonoma:         "4150aaffce87babe447a0e81bac040e0d08ac51c3617a5e14be88a953f1afcd4"
    sha256 cellar: :any_skip_relocation, ventura:        "9ad1ea2bbd0337a4c0eb6d4dcd315e88002c180ce617dd03c4ddc7bad8a6e523"
    sha256 cellar: :any_skip_relocation, monterey:       "d8eb2e5f44d4335ca023a390d52d26abff83deef693472f597c21024584b9fc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f21dc3fbdbf8042177e23313cf41dea986b8049f47bc222104a7e40004896490"
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