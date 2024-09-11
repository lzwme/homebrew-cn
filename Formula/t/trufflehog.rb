class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.81.10.tar.gz"
  sha256 "1f042d0fb720816bd2f7b74b1b089ea831ce7a21132e529462a5724d686897ed"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a41c8ca9f110b19244189b04a403f87143e4c2ff5cef8caa2a48b77d7e612118"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5186db6303d286fffcd0cdd0b8d096fe5f180ed56c41dc9d28734b2050c9017"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a6d61739542fc6d5ea1f5a1d50cf40bb343d7d613b43a8c2eac6304962cab0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41cf59ab8fe7250bfeb280f12fdc58aeccd83b626c9987a6cbbdef7bd9367dd9"
    sha256 cellar: :any_skip_relocation, sonoma:         "010d921942b46ba27173776cfe6684c389523c541e871bf81df397001dbe188d"
    sha256 cellar: :any_skip_relocation, ventura:        "918e306d9541a1ce6f647072be33dcab695af80a0d2e1f5881e5168f48c19078"
    sha256 cellar: :any_skip_relocation, monterey:       "4b8305b49b112a6e0cc8ca791759afc1237fda268eb4daaae659eca01be41576"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "375cfad7526fa27ab49921d5ca3789640d178342c55697344d2b2b43b1d5a495"
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