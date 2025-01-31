class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.4.tar.gz"
  sha256 "0caf5f371c16926849a9eca3e56b4c3524aa428e8f2ed4a450bb206145036525"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc1986dd5677ad71020f0b5e3ee3b6af1b34c2d8d1de25f25748d027b25a730f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e771e906627467264ed359b07da494fdc618136f41da729b588afcade0c0f39f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d73c03afb6914068573b11d90c0f12d5e759d31d9820bd5218b4a4fab0523a3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "31ecd7d6a54740a2d3786b15decdd38e28736b9f7f4c4722c340c56d26f3e7e4"
    sha256 cellar: :any_skip_relocation, ventura:       "1459946057dc727c432d9e66ff89e42b5d6dfca735166529d949d8504797c81e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29c510155c2a5d45129c52ad22d7ddb9951c28e8e5cb6790f37d7e90e242bdb6"
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