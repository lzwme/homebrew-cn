class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.79.0.tar.gz"
  sha256 "4bfc94b70a427160b2c57ea173b4a493149a178271ee6d01e2ec1fc868522f32"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cb5924962f51fc9653de185e50321739458d43b1f540f587abfe492078f598d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bee827a78940a2875cfe78bed4ef295f9310d5ff85ed32a1770a5ec369b5ec3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec0a6c8492f3e4a7dd65c1b423dd3232c7a37687ac7a903e8788f0c57ad531dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "ebf0a80346dd09bc661ad10b44e9f0830b80b8c99319ee6ab6b6d6010c9e9522"
    sha256 cellar: :any_skip_relocation, ventura:        "6145de514a1419c6440f6c6c1dac50a7919bfa8c66f02c841050c28d6da61253"
    sha256 cellar: :any_skip_relocation, monterey:       "c7215a86cf427f685f71795c76559f8f665bb3456ddd3a6bd8d3c29b9ff797af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e938383e5a680ffb049b1150e66b0ef3d5860add2631d3565d2f70c83a250169"
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