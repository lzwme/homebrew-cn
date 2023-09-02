class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.54.2.tar.gz"
  sha256 "f4d4f37386b74b17028e729e4c93dc86412fc609dc68f9503a634a268fe99ddd"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/driftwood.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "324f55d78c025f77975d7b6a7b8037f9dfc72479e946df47531c3cdb0fe9a772"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43cee0b37a5a73307a03d957f7ea75a37eb3a090820d92c3f8a39f735530b0f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c64d4d1cca090c1e8c1ee58954f7f890edd4169dc081a72047f9ccf228213ba"
    sha256 cellar: :any_skip_relocation, ventura:        "83feeb00af3b26e21e7e2df67afd2de55f58e65e2ec73ad48cbe87cbe852c18d"
    sha256 cellar: :any_skip_relocation, monterey:       "d66f0a2d61277718413892c34075501b58ffd9de699ddc578c0ae29ba15e328f"
    sha256 cellar: :any_skip_relocation, big_sur:        "302dc41fa491b1af7b4c950db21e3557657d6e99c670f85d8e6de765f99e17b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f90cdefc6f9c119b1622d3965360c3c41b60f465d75a0a4338b512315575927"
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