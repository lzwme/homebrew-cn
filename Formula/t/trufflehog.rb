class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.68.3.tar.gz"
  sha256 "e11a2402a6d0f5bfb3aee235cb611d9e56ceaefaa4572297b41a99e43f7a0be4"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de42f93609e12553c010b56245ea74be2f38473b71a67641254a8814c6cd414d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb5ce6f327da2b254dc10375379f167bd0c09ce5b707e5f8270a982d125e47e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fae64f22bdef1713230aa212a1b5c354991edc39e1add881c37efbb57e32d515"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b9f2084248bbe5970c759af3f4906ef52f19072cc2cafbb3edaf17e082c2644"
    sha256 cellar: :any_skip_relocation, ventura:        "416a9d216977a658cc98b06fe70a7531240dec3fd3cb4d573f709d9ddc191f90"
    sha256 cellar: :any_skip_relocation, monterey:       "aeea2932709ea882d3931310732f1c4c072566488fab854e51238e6089a1f806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dcf6d91047ce1d1090528c4d2705c0bc920b3d91b8349b6d2c7554d15487a4c"
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