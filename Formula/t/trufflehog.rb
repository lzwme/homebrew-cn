class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.76.2.tar.gz"
  sha256 "1b1f659ef33a99fbcbde154ad6005d54f940b978a441d87c7eaa3f38db9a0e4c"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddc8550ba5ab0074515eb650d87204a56bb8e0d6c7bf326247730ed853497e9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb9df7a03de04634c461770f2c36943bb31cc99e8adf03f72750f1e70fa72775"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f22fdf18aff54748615b1f4b6667cbf11413d3aa6a9027710b1f4ddcc8beca35"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6e6590fb4e8e88e86a81e62569593e677c0a1c54a427219c971eb37f2ce41fe"
    sha256 cellar: :any_skip_relocation, ventura:        "80a98458e903fcd8405cd40da5ac7788516ef8f653f805961aa4e949b5bda290"
    sha256 cellar: :any_skip_relocation, monterey:       "b1c569c17589cf5dabc666e11349f36214bccd8a924e438ea218c0c55035e88d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22336859c714087afd4f11a085b4c26fb6a4a35459a799e7284c0b425eb07b39"
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