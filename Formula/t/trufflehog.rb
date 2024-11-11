class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.83.6.tar.gz"
  sha256 "e46fe3c65c7e839f38b8ff93b54557fcdddba049f1e4b7428b34721eaf1a6a80"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "342011c461bc82c69977c687dfb2d021c6235302d1f7c72fe69e8260dd214d50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20b6d81a938026d958e98f7317a315b14f76bca60ae91c5a3ebb45b4d2d9e7e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95bac205bb5b56074854d72171e51e1e16c11d5e33cc5518f6471baec847715f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a6bf55aa7e9d5361e3c26ce32548f76f1b35662264e79ea26f3585254dc3b3b"
    sha256 cellar: :any_skip_relocation, ventura:       "8d841b08cd7243855768ceb0ac43570eb27a34f7ed267f4773079408e8b59e42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0893a4ab0fc4657ce6c5ff75732ed96c9654f86acc20c6802676925a8cc7e26"
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