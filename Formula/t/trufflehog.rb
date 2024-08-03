class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.81.4.tar.gz"
  sha256 "c4ac853e5fde26f2599871a0ff3f00e6eb411e438289bc5786d8b832df2d3215"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7dbfc3e9e10db5aac8e5b1745fb703e97b922b613f69e49e0be920406f84cc8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8929ad750afb87a89ad0bf04edb090aafdc300815848424422f4d8bc44ba769e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "545669546bb09eb95b11a835bbc47c9105b5b18a57b2e5632bb37eba1ed43252"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5f33e2b986182fb2a8a4be0f2e368283603c80da5fb91d050eef38e12bc363c"
    sha256 cellar: :any_skip_relocation, ventura:        "21d1a0bc926f7ce1650b17cb365a346871ebc3881f3871367bb088885605661d"
    sha256 cellar: :any_skip_relocation, monterey:       "449d56b654ad55362fe61786c47920ece64275ba5ba2ab3945cbaabf8c3e5914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f1c0654b277559da2660e51796c92aa6457649de2dcae8d2b93d4e66f0bf0d7"
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