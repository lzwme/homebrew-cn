class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.63.11.tar.gz"
  sha256 "c8b812ee779c68a310fb14c357700ff297dfa6b44aa1b542e4f8f1c7e59d80a0"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fe21fa7fded6bf92172310e7ee0fdfc1db109f9e4a344f1a48796152de2ba47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5d5203549a88b3a48613afbf7c87a19e1a0a48d9a39aaa6fd5029b9e7306388"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1f991c57088e78cac669f6c7cffea66e0dd1474784ae66618875b5854546461"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d9495fca1fe018886e6b823ae6de7cf02446c138af6e6687f366d0d6a2c723a"
    sha256 cellar: :any_skip_relocation, ventura:        "f286a3594c88877f2fc9f2d4dc4e2327f33f35bdcd86a8e14dc1dad56868ff42"
    sha256 cellar: :any_skip_relocation, monterey:       "f9fa8bd0c9d853a65502f18d5c8acb3e2d24511a7184d312edefb31a0618fd8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "714568229b8a4c9b022ad401c48a41dea8778097a433e413e7e475010d4a1849"
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