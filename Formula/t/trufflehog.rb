class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.13.tar.gz"
  sha256 "161aba1c38066b97aa18a6618ef041f583673137800f64dffbdc4f90c9cb7af4"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a983df4f41e3e13830873e15e8f0f22e2dd0756ef80983534efa6cfeeed26ec5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8409774319d24e8427dd197848048c9e781525ae8b8a6b539a316d6c9f220c7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1dc2492ba22d230edf3f973f73e0126dce84f7f947df8e2f59920c349991f01"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c9b10e9fd0387dc5dec8098dc57b753654195211be1793ccf19f29823369b76"
    sha256 cellar: :any_skip_relocation, ventura:       "ac6896351119d8994c57a2cc755aaa9b00220f96942dae6bebda81a67af435bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82228af38729b670d61c9b187074eb6cc50cd51c71e08d6f84f634790fe03881"
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