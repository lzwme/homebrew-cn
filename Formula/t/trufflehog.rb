class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.83.7.tar.gz"
  sha256 "ab2f6ea5869a7bed7b28b9cd22b79f867770de3e0b0afa4afc3ffd04def98f0c"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfa0712e03d2636d2126b3e0ea84ba7528d5362c95570c5a397531f6e8278ba9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c14bba8a4c3b7c3633df93c4d8e8cda48910bcb5beaa0f6b35dbfec19b79c80d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fbf655cd95824f14435ac5e28454ffdaf903574181400fa853647eec9a55b3cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "92a6febefcec334da600fadb93329c8da731526aa0159dca0bfa1935873426a4"
    sha256 cellar: :any_skip_relocation, ventura:       "3022540c613f58dd901c5fddc0e5fcd81b47256907358a4992a9f687dca92aea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce576e3f684b31610b7bc4008dab40732617a0d6d5f8564ebe6478bc5315ee32"
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