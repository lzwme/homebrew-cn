class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.22.tar.gz"
  sha256 "bf5b22ab059cb3a302186c48281c9ec264c724f1d2240ab0045df92f7d19bb17"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33b327e8f39b20defaf22976cd7ced07dc9d8e6f69378b640d103572b978e63e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a43b5c192f7488c98655f4ce902d8ac7bbd382058fd0b0837c8bb2da2314caf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a42d0a14ac88afcfe2ab7a42eccf7a02f91894f44b2c58fd0e937d9bf8481bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "521aff724067a0dae1d8e65c34a93d678060e689dc914fcbc94fe67745c1b928"
    sha256 cellar: :any_skip_relocation, ventura:       "f1bf229c66afe55639cb2d4a247d52a9cf67fb53535dfa103bd2233d4c1e6b21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0041233e84c1e94b0d2038316ebdbca64b424d2bfde68662cd5bafc652db5ee8"
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