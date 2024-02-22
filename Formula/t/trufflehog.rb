class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.68.0.tar.gz"
  sha256 "ea1889a32a7b502484d91acb15bc061462c9adea9957a1dc59c0d88f18761c99"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e73812d0bd0a57936a4ea176ef627cbcb88eef5bdc1a65a1ccb55df011b45029"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec89d3474a97f72273f881aa1faef191aef6379c5d11779c824d25a142cdc53f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "222b762cdb17097d311c2fd1ec7b2f5781176fce2547822d2d0b1305c9b406a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "773e67e33a14b6b6d2197e7fe4c7304e6f37c92f7bac9163a798469bd9aa7c81"
    sha256 cellar: :any_skip_relocation, ventura:        "135d73d565338f0368d02c59e22e631c183697b24622a2cd9b970ef4cc887bfc"
    sha256 cellar: :any_skip_relocation, monterey:       "be0f2c13ddfa4bc535272bea17b5c97ba7f15d835dcd9caeb29c1f54e87a6f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f5a7328e742cd9e0ec6fa60a1c7400a21c2577c9308bafafdd9c1f09556c167"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comtrufflesecuritytrufflehogv3pkgversion.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    repo = "https:github.comtrufflesecuritytest_keys"
    output = shell_output("#{bin}trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}trufflehog --version 2>&1")
  end
end