class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.12.tar.gz"
  sha256 "5783cd3add3cba3fe1fd011068720c9d5aee131f0be76e54a2c7887852c61d76"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8758c1390588f3eac0a7338a09f9f67e9d79e6a5fd76b59fd10ef82b64cb6828"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "deb80eecdc043b69c8ea61d04e53142d8882a172dd4103547642393f879ce30d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67db3af11601fecdedf56f60fc01b0681cf07f121580364ab1fc295f4d89cf3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "29bde4e142cc1937a4742741c1cd4d04df8b6d8fe0855bd97f0fae6cf710ecd0"
    sha256 cellar: :any_skip_relocation, ventura:       "cb5b087e183d8d945b0c0672f8a9a3d04306ff7f44fb0d2f97fc68d89b5045d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "367c6a20c3bdcf3c11dab77a444403f893e3e7686c0619d73c63645a20022ad4"
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