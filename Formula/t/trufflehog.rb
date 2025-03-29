class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.20.tar.gz"
  sha256 "d46d8bff19500efc4e63ecd7940da5fe93ac3054d978e6c3deefb17bdc43e54b"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb458a20c2f9d63bd58d061a430132429bf96557070308c34c5c08a1c3e0e192"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd450f207e7f7dce940b4ac09c5e86394538fd36b499d2115d2211c0f85fd6d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb4135112a2b8df4b22ac6bd655c62c3bafbdbe7cc29ba1b3180429846d86682"
    sha256 cellar: :any_skip_relocation, sonoma:        "69752cc343aee05c047bc13bf24bec9efa5e8580b5e9c7e8e3d961a83a469d3c"
    sha256 cellar: :any_skip_relocation, ventura:       "d9f7e48988f70a73468365c25946a360571edcb5c4d29629cce94afb84b6f816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e52d56e24059f59f9e540768e07d72a953fab9457981938a0a769f4a75a791a"
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