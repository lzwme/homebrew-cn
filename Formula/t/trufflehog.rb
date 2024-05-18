class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.76.3.tar.gz"
  sha256 "02bdf7c30117c7e86c4c660d4ec6c691a5b4188ca27c5c86151f24da44f065b7"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19a1a6ea0cdd1a5c15fa1cde77c89f45a67b4b430fc6c734ad9c444bf81298a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b6b1b379f6db194d215faebc97de5b6fdc4bd3313c0d2ee6930ea3753015433"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4e263106620c8da32885a59fecc383aace714ab9ae9a58a4a674c281ef8324d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e96cc83aa1ef70060112eaca04caf957a4313bc4ed38d0f9b7d52d74f0ab295"
    sha256 cellar: :any_skip_relocation, ventura:        "5795add004f7f8a1f6307a5341860487b76f9d858f85bcfefbf218d4c962764a"
    sha256 cellar: :any_skip_relocation, monterey:       "a4747bd5967633cb077f2dedfeeae6373fd906b913d550f12ed6ce21b00ba716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5290989e71f444cf487509c77fe0b898924b75fec214e63db29730f90cf34fab"
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