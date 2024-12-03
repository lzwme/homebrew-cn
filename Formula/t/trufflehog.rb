class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.84.2.tar.gz"
  sha256 "59d3caa2e603c2f268068e550e1aa23b3ae078ce3cd1f2c23f1ec73228442ff8"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93a5a18946e66f01141693e5ac7d4dc390fb162e17f90a0b3ee4fe06c3bf5cee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aba7fbdf4a6035d084a3ee5ffd779812cd75e721e9d5be6fbcbd344f50e6a8dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4923f44bc9843112099328abec7f335ad8af02501f329e7b6fc61d208191933"
    sha256 cellar: :any_skip_relocation, sonoma:        "faf6c20ff256d27b2e6d50604d72a4bd0ecea2ff69ddf77794d5e32e492f733e"
    sha256 cellar: :any_skip_relocation, ventura:       "bf5e960569c7a3dbb900b2b2ddbf033456cf18e67572ab3a350acb3b35b25b4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bcc198c2abbcdf4f450c22fa2a7c550969915818d2eb38e4bd97471c4cf9d35"
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