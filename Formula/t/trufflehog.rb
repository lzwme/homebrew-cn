class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.80.2.tar.gz"
  sha256 "489eee4a4ae309a80b413481a16dbe9965a1c18ce83fe0b373896908775d2375"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16927be14c0461ce8c4b42b820b673d178f71e7756283acbe01ff0259faf78a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d85d2411b2584862a806f3b78220b36d8bd5263efdd8678a066ce24018ce6a9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b46c33dcb2f65ccdec08aa693f0c32cf90f77e3f713454cebd3625b25dd6145c"
    sha256 cellar: :any_skip_relocation, sonoma:         "935058a81707acffa10f9a0b2f5a2a846abebe8260b4729465061989d0b406a3"
    sha256 cellar: :any_skip_relocation, ventura:        "bcfcb5478187af439628165fc6571306177c83d170ad4130d8c60bb8b602764e"
    sha256 cellar: :any_skip_relocation, monterey:       "66a47b8fdd0e83b93a465b5f631ab4e05743c58837ac347b855320ef8eff78c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d9e04b9f4227728d19dd69669cdb2526d00fc4e58b8bae4248328d6c98e3fb1"
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