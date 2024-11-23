class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.84.1.tar.gz"
  sha256 "686fc8bfdea4207606db04d8bdd55fde0801c4628717260d5b8c4bda828fcbb5"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a2f143df4e37efaad6743ac05cd5498a3c5890f713f6bdb4fc6f7ef09979853"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dc06a8f2c2f4f6606db15d72e5d229e24ee36a9c118ecff4229912d43f032f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9732374f38740df24d950b6c90358c1743b08d78acbb49f28ba88f3a0212e04a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ef8f192a6b13377a08a48e80304d23d2fa0f6a7a61f727e8ec0972465a30a6c"
    sha256 cellar: :any_skip_relocation, ventura:       "11aa965968a397fce2f0bff150e6d4e46551d88ed0c1ff281bd55963408294c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ab2452ec2e3810087d4412cec4d1abe7aba39f6abe0965f18a310732291e315"
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