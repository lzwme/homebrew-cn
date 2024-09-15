class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.82.2.tar.gz"
  sha256 "b6b67f9575f995b60ff8293b95e4d3e83971e66e6cfba4dcad466e8e6cb8f53a"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c8f0bb538ff6968bfe747f635cf51d9c3befb995bc5dfea4f50dfb2b4e0f497"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e6c11e1a95679851a7d38d09aa1ca1229459c1097ee66511e583cd986db6155"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3cbdbcdeecf8f2f4fa0fc23ca990ea04a81d3a6295d2ba9747702ed2e51fc2e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa5af43485abf3a12c524690ecd17d780324eda4163d3eaa0566a9dee0babf56"
    sha256 cellar: :any_skip_relocation, ventura:       "32f6d0e73a3830e66ef1fcc60a5971f016ba00b5bf64b1aa25543dad08bfe1af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b91b716ece291fd97a2b5e68a91208f19000a87c187aeeec16e70cd71870f81"
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