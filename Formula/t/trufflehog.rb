class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.82.5.tar.gz"
  sha256 "32048ae6f45621537f7a474ba1ab6f0746127091bb86f770a97cc7912d19349f"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "711a20d8aea61386d7f3a96390e56fc125f8f0d846c9329000f653c669599efc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9575cf4531e84a2e87669d285751491fd5ade04492b1e46a2c09bad5b6e7b0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e415abba8d2d7471cc7ba5a0d36ce6158fba1a16bf837a48daa4f8c39e7a1459"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cb4ab6872940d54c796c6ebccad144424afcb98a646590eead3cab7165746cb"
    sha256 cellar: :any_skip_relocation, ventura:       "dfc05faa6b1865a9768a5b348ce82f9d7ffa453396c018682b1e9c416f4af111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8eb2276a8d9f3747122dedaa96eafa3730bf8516c421e478918d461080b20d25"
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