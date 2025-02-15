class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.9.tar.gz"
  sha256 "b2b788eb3b7ef06b4b40cc446ab0b739ac4094f2d24656b10c47dbd76812e1e3"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c530dfd5fb2f77e97fe0f089b6260164ce9bbc3ea32e966efc704267415dd52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a8f0b841b124b9fa780c5d28527b759bf4e748c58a84e64a29053503c1fe53d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3cf791f902e3964396e15d8a9f65500ee36b1f2a7341aefad44b21cfcae17963"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b0c17fc7ea396a2eab8d8dd8a535b731e670ecd35451f626899ad87daed8b9f"
    sha256 cellar: :any_skip_relocation, ventura:       "31576fd037fb9d2a1e9351b56aec3497ec243daf339666e518161e6b7ec68919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ecb21a4b81e269a8bb8cc2bde107d83c0e890ee2fcfd6c6ed8d98b5c62f7b40"
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