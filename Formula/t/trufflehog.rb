class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.83.1.tar.gz"
  sha256 "688526b61dc8a9b5c784ab12ab62df37c6a3c6dd1d2bf57590a57e8714080da5"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "001df3adb4062d660552a98100a900a14447b536f7b0514948924e8bcd8781c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0594f4d1522bcecf6d654a835d788e4cef28ca7e2caf78588e4a2c71f4e1226"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20e3c393dde29e8be575cf8a9196c52cc433b55a71546f929fc075f4bb284c1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "73873a2e5d90d8d2322fb0f3b7b9eb0f60abae0b6040d70701d004609e79a577"
    sha256 cellar: :any_skip_relocation, ventura:       "e6c55e0eacd48bd55217acc18a8d29afef12a988d21fb64bf618f49835838514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb68a0a5cb96fb853aa68dcb07d86f68ad81df77ddaa83a66af9754ef5e547ac"
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