class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.30.tar.gz"
  sha256 "1713f3db815aca513f2bba8535d002d8a119d7ac303a7563ec42e4b9861430dc"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0648f94d7c2f9e39b8c4503f7d2f913adddf1fcafcd4ede0a60a2aefe8a4d2d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd3ad51f0a570ce9a4b5a9fdb8f019a25f689b9b5e074409d37f955ca210ef62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6900badb8f431e17bbd65ea782ba4078cb59d323f2c1527e1c41eaf0ab7d7d5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3eafa1e4b7ccdf5b50f98d826a8f6482a6928f962b99e666bba2544684e086f7"
    sha256 cellar: :any_skip_relocation, ventura:       "85a64e83c309a2ce3e2b86de07c2102c998a24a2940e29032e06e2f3c5baa505"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d117b43fae68b4c5d2340a0075489353b68878fa8204669eca4a037c57453af2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa7e8f1d5da4bf6f717eca266dbe34a297a70d9747f4d1923e93f4fd33328a06"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comtrufflesecuritytrufflehogv3pkgversion.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    repo = "https:github.comtrufflesecuritytest_keys"
    output = shell_output("#{bin}trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}trufflehog --version 2>&1")
  end
end