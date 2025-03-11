class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.16.tar.gz"
  sha256 "8f0bce9d8ac390a5288cc83feef782f91c223e0607897b2c15b4820194e28990"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17c64ce2a74f3852c7188ab3e017512420ae90864572a491a246416b0fec0610"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1aef711af50fb91deb89222afef63fc3ae3738e2a281dee2a0601bd3e6e8d26c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9b6a75405448aecfb9bfded0635952ed6c34dc14ab49d2d3fa6b5643cf778c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "665817985e776c2a56e7eecc5313a6df71201fecf419a626434c82a1c97b498e"
    sha256 cellar: :any_skip_relocation, ventura:       "c5bca7de4e39efe60e5239eb251b266d13d2cd0f410d5c0ba49ba72db7d310f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4e0e4a6233533ba96c9680adecf96bf5f151ea4052de74467cdbc8b37299c3d"
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