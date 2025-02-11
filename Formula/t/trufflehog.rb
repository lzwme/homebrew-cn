class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.6.tar.gz"
  sha256 "deefd4945834785cbcd80824d8c0301ef200ba91040f46d03f3fe34cace7ab19"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7068f79d1a77998faa00b6bb4002b9180107adc6032093f1234ecb570c72d262"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4d99953ee90bd9ff21424c56d517ab2c281f5e594ca4551c94ead8ba5976bc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c429034e5c87fbf9eb53856dcdd63914884ab94f93c503fb3349b35721d729d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f931a2f31e8dd989b513f123b67eb9398b90d11ebef8ecf940e42d1c8ece5ca"
    sha256 cellar: :any_skip_relocation, ventura:       "266c393da0d9d342a7e25cf2a8803c98cfdba81a6412546cfda584edb680d55e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a98d14fe82a2df788b66bc712e2d8a3e5e5ab56b3e061dc8a53f5c30fd69ec81"
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