class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.82.12.tar.gz"
  sha256 "8840d664ff4c6d40fa8df27523fc396488ced9139437f9ad9775488acd11674b"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "347f073175df4890a6bf322e2ea6a61e8c52e29919191c1dfb58f792561eaeb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82b360068659678469d526cfbf02c4255a87c21cc4525a5a336fa39802e40ee0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d577b98b9231b0ee7cbad1591c04e3487860ba669794d225760427e6516d893f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5856ce8f195e9f9e7b99ef0a48253f4070f251a6942612277327ae5cf04da67"
    sha256 cellar: :any_skip_relocation, ventura:       "6b8dd76552745374a831ec7be514cd9ad21564453ee1b2f568cdfc1cb6ec5547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c404d7c86851ae0f8b8149ba112a55207ffd64279b3124080b57da9fbd602433"
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