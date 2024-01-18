class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.63.10.tar.gz"
  sha256 "a4eee675703950e15c2dcb9f9068532a05fa466895904dff42d58e6a2d9ee87f"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4080f4617cc6c5f859b42c0a2cd2ccd2a604c0f8e9c6b5c219743cf0c78974b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bddecb86947faf5e034f3d5bc82a4c78070d3aa2ec219242fcd286cb46fc69e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee344d5ef1d30a77c9835a86a710f19b305e0dec5e00829898c08d801701a058"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e16f7b5eceabfede8884117f8162582c5cf964a82e382de1b4524a60bda7563"
    sha256 cellar: :any_skip_relocation, ventura:        "02315102313832a5f7bfc29942f154c970cf1eb2ad0369524a8d087da6365718"
    sha256 cellar: :any_skip_relocation, monterey:       "b7609b98f30d2ee2ff17f207938e370bed66d66dcbce161e93455c3f5928e685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82092dd583e0c7d77b1465fb25720b1ab63fccc14fa5ccde9aa4222946631ee8"
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