class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.3.tar.gz"
  sha256 "4d6d2c174a515256e19845d2cac828e5da55d86f022df8433c992443c786162a"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d57c1a2c2eaedecb875fb185fec9492be0d3dbee5a2e15d32e76d0eaf9775a4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbbfbc67ed4ada164ca38417b6d2a95074130d977b00b144e099692d6db38208"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3614e32acc416e18cd9a44cddf42a41cf6c54037ed3a0cb053118e64eac1e05"
    sha256 cellar: :any_skip_relocation, sonoma:        "2be411997ea620cc53a8d584564061f7b0f101a1ace08652605710e741b2f556"
    sha256 cellar: :any_skip_relocation, ventura:       "782ec59e460a3b69f631039e19d727d130f13e024c9fdbc2bb686bc4f25740fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0288c8ad7fcd0b4392948576c53afb5803c994a612e6957cbc3ca61261e985ec"
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