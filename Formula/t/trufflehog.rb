class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.71.2.tar.gz"
  sha256 "9f17bb7f7249ea02985b7bf3e526b68957249eba2b4c352f95f2f93dce8d62de"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2d643afe6cf627f6166f9e8af7ba4c14d9d1456edeb877a56d0e01270f9e6a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "248aa6ad9fa37492e30dc7ee8fd677553adfabe67b06001a8289cc856a5ab455"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c4a071c50682836b284bc1bf07b7ec1f4fe6daf6e51090f41a8ffb718da39dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "a828aa4a18024689423d4f2f3570b73bf6f31ebfe4b0dca4cb15cdb51e4f11e5"
    sha256 cellar: :any_skip_relocation, ventura:        "3c16c2a65d9ccd9936ad06075c9d057b143a4806fe5832d9e93531714975fe6c"
    sha256 cellar: :any_skip_relocation, monterey:       "754d2deed8c8a9ccd2c997e929be21bbdf6396c53b8467a65990515301d2ec06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec5b662746db727bd6c20a961cd2529f0d736545ab345ee39389b0e50fa367ae"
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