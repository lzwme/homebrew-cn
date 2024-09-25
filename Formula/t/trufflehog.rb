class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.82.3.tar.gz"
  sha256 "a1574bc860eefa6c44d79ece82937b18f5dabd54f86ae94975a0a309638753b9"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7b248a6e43851198ea589af9edd19317c8c96f62050241904f27b9ad23166c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65ec67dc90acf9b4d8a5780be20549c3727dd576ad593f449e9a95d086f0a3b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca47c2d868d0e026cc2a4afa0e8a74001ab679c4e79d8c0d76d4802a3b6c8cc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2e6ce2b7a236cda0b317429609d347c6ef644b41df5ad3bd2eaa5d5d72e98e3"
    sha256 cellar: :any_skip_relocation, ventura:       "4559e901379a6ce391d23b25637ebab4010c41ba78f627aed8b3f28eef6625dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "508fd3290408b857c3facd5e865440ffbc26684a7f351851670541214ec48dc8"
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