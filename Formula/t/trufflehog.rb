class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.24.tar.gz"
  sha256 "ea921aaa1b8cff232e778fcb4626680b8f6e321581907c56da4fe1b615cac175"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e734b8c87337beb20ee74695d936a47bf02d02f688690b769d6122b26d3a27a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e564bfab7d15049e6fa9d0b65e659e6a570b49b5728b5d0e1d97cee4f0f1b2fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25263a1c1fa19dabf06901af57ef34a9250e051f1c6910671000a208c7dc9436"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9e1da4cc502b08cb2afe88cbbdaff764729284ed01275db69c9a56ab4e2fc2c"
    sha256 cellar: :any_skip_relocation, ventura:       "bb29e993100b8bfbe4dc6d9f77328ce851a9b44bf289c8939923d1b921b0738d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a03be6f1b5c87c543f1bfdd98bdd68ca041390269b181bfdeafbcd16df99544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2a2a9b1a3e0c4b3e1673b2495217465eb14087a469443d4d2bc9ac29bd4369a"
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