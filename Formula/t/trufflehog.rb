class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.10.tar.gz"
  sha256 "68fb40dc87ea58a13ed2b31ea93f765b9f373bfbb95e4f784f867c2c47dc0e90"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3c700c6eb2a5dc73a42e2d8d90d72e0427f4d14cbdf3d9281e612463009b5a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5bbc3ada208cee31e0df51869826282da46b6787ea4db98cb5548714daa25ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9af2b432bb3bd1712baebb6f08760c76bc24db69a607615b446fe7d69b9f4f9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2760eacb9068afdf1502b6057c8472fc7096c0fa8522dc31d529e7b32c484711"
    sha256 cellar: :any_skip_relocation, ventura:       "ec93b54c39bde7cba9e4bb9e909e65b107524e6ec477917b47572ad65427c947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef301480775dc3b8ea551c6d8ec99ec7e18e555e4f287908e8ab32993611f59f"
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