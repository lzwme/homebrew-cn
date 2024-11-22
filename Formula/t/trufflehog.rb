class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.84.0.tar.gz"
  sha256 "672dafa70d9ebe8aa7f300055fbbc78fae196648d4e73bca29968db1354b8520"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a56c734dc280824a8b8ef9b21b86a8b651d11f4476615c8e0cc8941de8fcccb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38b2b4b9f1d8f3b37c4ed0abf00b907ab86c70be3dfe55162c7ff6c097158353"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "571c7257f9178a10af6dbeb45e57a67461312d01eea7ecf009706ada814432fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "e362cc013a6c88cf22c0d6984abfed345681d04556b8963c44694b0ba6d80aba"
    sha256 cellar: :any_skip_relocation, ventura:       "a755734079f0d75062cc6ae9e4e16cf9369831a178f4849cd161a68e413f7650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "996718dc3be9bf039cc44a06c5a1b41a861c992c7ff41a73336ea2ffa63d7c94"
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