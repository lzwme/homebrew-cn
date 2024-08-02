class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.80.5.tar.gz"
  sha256 "4d7adad4a0a786fe030b5fdccdb61610253600a49dd3b659964d007a7b112c85"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "219716c87f8fd67564a5137a9c11cf1f81c624a77c95ed1488498d07026591cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21937807d76f7cdb15ad58af4f19a8adfd049f08cfc3b118e139834b88a3660e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3256680fa524041ebc5f8a734c8e3223e3fea82fe410e8dde76660af8c02587"
    sha256 cellar: :any_skip_relocation, sonoma:         "35263b613c540c638e82cb890c7219382417164374466b4a6d05718c39d55319"
    sha256 cellar: :any_skip_relocation, ventura:        "746d9927937d05c1a073373696b6fb8bfcece277e1dd7a8ee2938350e3433535"
    sha256 cellar: :any_skip_relocation, monterey:       "950768ce7461119e2ef824b26638b43e014d521da61a88a1347dad7ef326d200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "462135325b3c0f0ffd7e8d49f6a8d6485b2c1cc68dde87a0ea5ac3e7f4763f02"
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