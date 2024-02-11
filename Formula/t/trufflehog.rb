class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.67.5.tar.gz"
  sha256 "8e9c10a655682c97b4f90ade26af4eade9334f4ee4ffbb43d92e77803550e124"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aea81e2351eba88847dfc05dbe8ee05fe53e4384c0dce9ef150cccc0a4165adf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d5e959cc5d8f97fc27340a6ec799486d9d8b0c7e4bdf67842b0a6acee7141dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac68972e91be763f099f7bff6002d3156661de675279bd1fd88bcdb68e178994"
    sha256 cellar: :any_skip_relocation, sonoma:         "493fc3c676c3c82dece8aaaff17a77f966cd386b8027f281f4776cc4ea64cf22"
    sha256 cellar: :any_skip_relocation, ventura:        "c5b7992b59d27662a3c69c07baf16ea2e896fa1e56079b44f1bc9e51ea2c10c0"
    sha256 cellar: :any_skip_relocation, monterey:       "855a0419c6c6fd2871f5f6069f764c322aca3bcfe76dcad548bd37f88b5864f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40790931425069a067f2e846d8cfdf3bad08677d2a36719649ae424679f1409e"
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