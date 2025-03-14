class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.17.tar.gz"
  sha256 "8ab59e272e30e69a7ba4f44cb9b3973b9ac6ce56ea42f2829d6c90e2175bd23f"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebb1c45e410a50df97fd74e3a72210328bcc720157fc38f820b385606b4951e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2497fe297d40e989af3f07aa67fb7ee2c5618bedc7ff2e613bcf91457893812"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5be72b1b57c8e0702498c1026dff8150b4e48bf0a69f0baffddc902fbd05505"
    sha256 cellar: :any_skip_relocation, sonoma:        "f48bc2d76ed4bff89f876c19f9aa2c61c6c978f198ac606bd078ea0c99d14ab6"
    sha256 cellar: :any_skip_relocation, ventura:       "6309631848470a92508bef88f9a93caa2dd8150247e82290792d3022e1ce78ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "809e7ada0c4bef3cd51a7b19c0b9f42fffdef37b6686c9f7defde6a90e974221"
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