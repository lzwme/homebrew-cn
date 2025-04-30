class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.26.tar.gz"
  sha256 "2373a0fc940a99ec94a2d3a2bc343584da481438f219d0ca283df2e0c1ccdfe7"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "077f2500b02c8298ea407aab7cbfc2281524aabc4647c4483b7fb0507d2d8ebf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc227ee3aaec59605811d803e373e060469731800be3b32f58450a551515ce70"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26ed1747276f544ac6e2e31bc64bc98e7e913c5538ae3bee925a0d5eba52b74c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3638a08614553af92ae8b634ed6be4de8ba6e8843b7684bcc2aeac9d9ab4aed"
    sha256 cellar: :any_skip_relocation, ventura:       "c3c8c05f6d73e1719a39225f11e71e5b5997b0fb29fbc48c110d36394f2f622c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98ec6c788e203a0a802ae55fe411ae9729ae439e97a4886a09f13a80a0eaa429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78a49779a1b858e780916f5da982f00398bb13dca144d5b13d123be5ac5b785f"
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