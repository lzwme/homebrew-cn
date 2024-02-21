class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.67.7.tar.gz"
  sha256 "6a27b57a7f8ca69f2a60ebc0de4f86bacdc5568b729ebf985f00f4dcce01ca25"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7440109ebdd8013d178fe59b0e80b168382d43029978feb918bc370e1868831a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab6bc83e018afe4b2708525037722d38b029e5abc078595e470c2bfa49ae37fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41a425e7dabcb6aceaa686653d19b5a40b1fb6dea8e54593d870f09227253a31"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c11c3086619a1c0bfe64d85d025e5bd082f12ce49e6586faf2f2bb79a20bb6a"
    sha256 cellar: :any_skip_relocation, ventura:        "e38e92a6562189c8320af7a57a834dd0c2cae2e0b326f9c3fc2842874318768d"
    sha256 cellar: :any_skip_relocation, monterey:       "6b37c015aa7f7e438be782641fcf7c27ee71b1312f2dfdff227bf67868e36ce2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cc4f498c8fc328b91ee995b3555daa15836a5e9165dcc790d87ce9ee950a627"
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