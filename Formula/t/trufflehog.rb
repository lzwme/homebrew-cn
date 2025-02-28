class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.14.tar.gz"
  sha256 "89e3ffa727380386c11749639e9323b34ee5938b8cc2ee4538a1f2e44a1fe8ac"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21403ce5eb80307a43889c1d4bfc3ebe08fb90609033e00ccfd69efd75509d2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e47c1f72fa0164eb4df50f49707c86436f08a4eb07349e5c894b8c0caed3b0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2eb99c10ac4c1e3a1e506199fcaf9f170e0299b53e68ae5f4aa2d65d996e099c"
    sha256 cellar: :any_skip_relocation, sonoma:        "cca6911af01ac51d914892819b4309a35efaa18db3797e41f0c67e9ecc780d34"
    sha256 cellar: :any_skip_relocation, ventura:       "857fbb18c4bc085889b341e0a55b68a00d04065ebe832e0b3ba81b803db138b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5aef0f8210f6f12871c5ac35decd9f25056c8d98ad3b11ab6f018772d215f7f"
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