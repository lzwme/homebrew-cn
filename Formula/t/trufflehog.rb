class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.31.tar.gz"
  sha256 "03bb20827adc8723655e002eb8a82a161acd802f314e070bf3e390b4d3d50c42"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa515b1d677e5d43d1e6f353feee52f874b6b48c7e75c9d462908c36e610fe0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a95d6eb342bcced96d556b11e2872b74ee2ed1419dc6abde7f714bbfd6344f73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae3fbde4d03714004b3feef83c300a18d6bdc376855355adb34e154382697bbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "daf672a28d8f45de1b235f55861a78e8190233e5ddfc7c000be63c36cee087e4"
    sha256 cellar: :any_skip_relocation, ventura:       "030073bf376eab00f54dca469ea32dc99cd38c9eaa9995bf56043b8bf22c1c85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6b82cf2072b8a02d31d15a0bf5fba3f2d79c7b4662de81590661e1e63aaae95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69608849976473ed69dd0cfe034fe2ae7805ad7a6692cc7cd1ab046a2fbdfbe1"
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