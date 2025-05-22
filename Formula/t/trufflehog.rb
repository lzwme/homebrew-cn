class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.32.tar.gz"
  sha256 "10c8eb5858afeb0becf24609fffcfe30ba2ebaff945b95ea780a9ccb8f230cb1"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c3195fb00e5d7c8d4dd85269cb38ea01f53f316a02e4ab25e3b5c34aec14a9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "452bcac2e5cff7d8890fa2fce4a288c1a67eb4dcdaa0a49555ad0332f5b3216d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1075f640d0f34378269650c5902f91c0ac2722877a1c78ed410f68af49ef016e"
    sha256 cellar: :any_skip_relocation, sonoma:        "33482c8f325befd2ff872ee7636080bee59534b344a6659e1be96998af2119ab"
    sha256 cellar: :any_skip_relocation, ventura:       "e69ac6a3b387c240a2e19613b0fc295fbfcbb0b90d9698fbb30f1b6e7c06c696"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b24c5da5f23975e29d2b3853ab95febbb907254d85f469301a3351efaa65807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82924ed512167e49ac10af3a0cfa52c6eaa3019e041110027e34dcc13ca68750"
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