class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.63.6.tar.gz"
  sha256 "23fd07ba62ccb125174a0dab2ce8e14451d5038457cef33d8d075b79d31278ed"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "995b0c7acd9f123b1253fcebcc657c6a2819d0c6f2cfc7a827a7cd08daecf20b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c877d3196d37f70d7730dcdbc1deea662a3ed61ef849017938d0f215605db655"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7913a310f3e7ba2a087a673511af55f0c6c36d1cb8102deea8792750bc262afe"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d51cf5380eb758dea0ca89b3705dcb56f1088d4058cfd00b6762050625393d2"
    sha256 cellar: :any_skip_relocation, ventura:        "add01e91535e4abc0531f92c6e093ed971115077eb2ae1aa1ed23c5e348863bd"
    sha256 cellar: :any_skip_relocation, monterey:       "2df3e5320db08fe15a97f9e529755f5019a1c0db5b3a6a15f04dcbf502d5093d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c04c071d535b695e03e937c18e817740fd0cb6dba8bfb6135c0af3516600c58"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comtrufflesecuritytrufflehogv3pkgversion.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    repo = "https:github.comtrufflesecuritytest_keys"
    output = shell_output("#{bin}trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}trufflehog --version 2>&1")
  end
end