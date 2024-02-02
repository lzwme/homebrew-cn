class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.66.3.tar.gz"
  sha256 "48d5c72121408be1f2320ba6330bacfb35796f469fe7063d670d8716ffa02a7c"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff2d536c1827cdda8114856ac01d8d09870edf7b8572f0d003c46e0a326ecc7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ec17ddf51008bff7aaf057d7c52024ed1575622dab6516b459ce29892676b89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "469bbdd010f44aabc620154deef110080b148a25fcfa26cdcdf151c34ada24f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "82d6d79b1c192f9f41a8831dcc24487a3e1898f6a0db2b96bf2c67827fa90117"
    sha256 cellar: :any_skip_relocation, ventura:        "f9cb6984667c69736436445c48cecff0971defaab13ccf60cf518252f9f8d88e"
    sha256 cellar: :any_skip_relocation, monterey:       "486c3e98cec0c3a2fadcbd1674c03051cc57e32ff123e92664b410701cdfb054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88cb34b399acb8135137a73eca6bc9221fa340131694c6226cb9fa84afbc063f"
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