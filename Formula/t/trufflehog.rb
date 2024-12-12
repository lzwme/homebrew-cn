class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.86.1.tar.gz"
  sha256 "798394f7a6e44da5581ca47350dab88aba4ac8d672dfe77d41ee66f128de178b"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "932e49653aba2c8c51d6353041661916ff105963bc70186e12002402202ea0a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "221a97b82b66b81454a827f58659db21779753ade85e73574d06961d682c8d12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b12a4498e1c208f80557d18f08d531588c9fc5c5d52f416379e54ea5db381e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d7cadeb5b63e0bf2778df6a152bcfd66f65433fc1cf4e833825dc621276c883"
    sha256 cellar: :any_skip_relocation, ventura:       "75247e508439983b1c67071d708f5dde61684f8724626bbca2052ad13042aece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f25e61f21145edd6009500de5c69b0484d05459fae3521e59613afea2fd1624"
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