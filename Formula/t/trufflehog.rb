class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.63.8.tar.gz"
  sha256 "61b8a9b2fe725f509c22d74121f1052be613f54a685f593acfa224c639b8ac9f"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cef511ccd842e5731b92b88830fd1324cd6569173ed701da6be0963c32192640"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d494bfe91ace7622f77bfbba7d758cc91b5859cdd66fdc28cb9d57ab056f7346"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3fda5d1d83b6224be31d6b82fbe88cac7d1736db9562aaecd0d0d3b3308ae7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1219b033f7653819281ae066bbbb6c9fcba40b0aebb677eccc3683adf4d4dc7"
    sha256 cellar: :any_skip_relocation, ventura:        "118d2ec7dccc4f78a1cfe973a3ce70a807fd0a5f9678f963394a3618219a4d02"
    sha256 cellar: :any_skip_relocation, monterey:       "da3f1cdf448aeae87df18d6d525bea57065ef4b5023e8f366de96802a9d27dde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ec37fbf239f10758c12b45adca0d6935501972dc4cf28c5f4621894e58b83d1"
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