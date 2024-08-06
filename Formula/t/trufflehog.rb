class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.81.5.tar.gz"
  sha256 "6bd22b220ddc336c487c8f016398305c22d67290cdd39437d4f440f56b1a9292"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a58345ac4bd94bbab49b88d3e3a8720c3c4eb3c411604689e733890ba9e9aa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7f1febc88e534929aca9de487813f0782e4a0b4f5450439a8d30b0ddbc43e09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a83b08070e77ddfcc833e18a2fbf676267976765cb62849b8679f3a2c4dc19d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "f997f8731a3273ac8a945077d0937736377384353ad7bf36ea7a8b25b28db607"
    sha256 cellar: :any_skip_relocation, ventura:        "ec98ed7df630faa5303a138bf2df40f2fc1ab439f32064454f06783d4c4c1b88"
    sha256 cellar: :any_skip_relocation, monterey:       "03c5a9538fe62ae1fb1e64475fd7efa0b496b84239f00ae784c1ae58ec0e4507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1847658b6eb9058bfbc0713f76df11626fa40375079b31a7004664bb224a7412"
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