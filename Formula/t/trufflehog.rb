class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.80.1.tar.gz"
  sha256 "28be41934fa2c5d3aca19d4d8777069a905f68ae8683b4982416c2077e60a27d"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81f5a9e5ab0f0c2eb5f96c91d6508e4c55be3d112760c80f5132f74c5dfb42db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9dbf3d60dcbacb818404240c9a57ad61c44ffe2f83df7c5741a85df10bff52b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "189b731c223e4c18ee6a51bd219bfc338704d4520a7b3ac785249824979b82bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "12458e8d2868aada7bec91b9c5f97cdecb4d406f3a74b0093cdf85b2f582514c"
    sha256 cellar: :any_skip_relocation, ventura:        "ae71c7aca426a6bd5537ced23bde9c5aebda5e6715b3a31c2f1c4888b0e1d5ce"
    sha256 cellar: :any_skip_relocation, monterey:       "b064c5efc61780f3281074b1e8ed3d419cdef7ce98f3e0ef3d384124f2a9b808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63797db46ec7aec2e8ee01cf85eb2a27593d63118b6d5278b343fc7cea623960"
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