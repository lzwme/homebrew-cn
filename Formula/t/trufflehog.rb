class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.75.0.tar.gz"
  sha256 "e1be155cb936995eb1d6d8f92ee8db338eed5063d122fc1eb5e1f4ed5f13bd0b"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68fb97a4582d76206d75bc9068bf2a20fc2fa54ae10046c11f1f7bed2c0a4761"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbeff5d36dd53b5b07f3ff39267329c61018cb4d602905a844744ef53130dbc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef9731b7096e97f316bf253ae80c185b9758e89425d1f7d9b3720967a8a557af"
    sha256 cellar: :any_skip_relocation, sonoma:         "8497ce38091d519e9844466642f736c3336617c2c4be7f195010fa2909671a44"
    sha256 cellar: :any_skip_relocation, ventura:        "27a4e4bd5f7e58b489616334ff3e97b8a5999ad409bbb31d0594b8f62c697e69"
    sha256 cellar: :any_skip_relocation, monterey:       "67dbcc8fb4dd81b4be30d4ae8e6315d3547851f19173e3e336e5e5a9d3f9ab01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0491a42f1d2ea2fdbb21e088b767a6734466d0d95cd4c8be675672b565b338e1"
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