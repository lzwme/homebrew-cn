class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.1.tar.gz"
  sha256 "00d10c4976b28f559a41b67c6b2904ef78f900e0de02338c2d9376889f0543cd"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "884281c915825d792c93ca3ae0e4bb3976f0edbd0e92d4824a63fa31d5231b08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1f347d0d53eb989dd6f687df2fc4a7cc17e25e43c6f87669b075932b4c2f2a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fbce30627ef95fb795786eae49e05bb686f9e38184729f4370712f376479b562"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6f3f0d644762172eaddc093dcf1ff53d417e041f834693fbf139b0ac5b5c660"
    sha256 cellar: :any_skip_relocation, ventura:       "26e9c583cd0e11029dfeb1601f9e45bf13a596e17feba5a13630fbb6b3eb43cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12ea9fcc1f54c382c6c89b8519b50ca0ab1e55cfdf872b976082b48313bf3f8a"
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