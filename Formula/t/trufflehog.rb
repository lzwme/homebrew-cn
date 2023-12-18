class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.63.4.tar.gz"
  sha256 "6ef20969f454d11e050a28ccde8ee46b5945bd3b3df9d0933487848fc0d60012"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1452099e8c82f2a953e291cdb78810ffe3f8c99e3827f8b866c6facfab80360b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ff5c33a1e6f8c41fe8d2e25c63ce06df6a43536e290010b7a05f17aa249e9fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec2eefe1059c35a56dc94663c614300f9cdec3e88bb99b9712e22be2ccc29ac4"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9e703116bbe3e5254a76d307a01a0a94bf97328ceaabbe684f2ea987b348400"
    sha256 cellar: :any_skip_relocation, ventura:        "6775051f3cbe317f82a1f8930e6feab7e5745683ea8ca1a8110cf52470b7e29f"
    sha256 cellar: :any_skip_relocation, monterey:       "f68dc1391f45431044ce44547b60f2d43361311d1b97d4aa63a3e35e589b6772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42d84eea9f02b257a7936905423bbaa348f84eb8e811bafc9568637ec034a4f4"
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