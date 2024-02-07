class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.67.4.tar.gz"
  sha256 "75933af217df7b235c6555e197720789ff92ac6039d9a8df0220eb92f1ac4ee8"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f040525eecef3ddacbcebcc7c7ba088a33fdf2ac1c436832c6611c14371ab6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b394923f532ea8c4891f58c16832ccc6afba2a471965c16ed3e38984bec03da9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c7aff1a8a3344293d946f9ee05110ccd4f00cb8ee82229266dae1dde7715f2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "5dc6ca0cc80364dc7fbebd0f10955a649e82d10449c19164505ca6d3bde190fe"
    sha256 cellar: :any_skip_relocation, ventura:        "e1f910f5bc5f217b5dbf0534d0c4d17e8fdf12b6e3cb46488c978076779b5809"
    sha256 cellar: :any_skip_relocation, monterey:       "4f0d83c91af2de70776070801b2254ededded5397a4009359176f9955d91c492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ff098ff41e8df115fc29f06b5720a96c5f6c95dbe1cbe54c958a8d592a8ef3c"
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