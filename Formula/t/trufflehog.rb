class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.78.2.tar.gz"
  sha256 "c3ba80bf0d847e3cb3f71fa566a30e3299a352c86016915b63a75dd77842ea65"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "516cea10608ab670a3d4cb6479e9c4c5f3dda854152cf985ff9779127694653e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5e0abd41a7f76b45fb81e406ff19ee94421a358a6d6ab834b41ea2f6799a5c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ace3ff8bb96d464b3c289ad0e2ac131787a9e0ac59d90832bff462a6e398f89"
    sha256 cellar: :any_skip_relocation, sonoma:         "29037df91d17afd5af32cfb8346f01f08ba6851eb02862e135bf46904a1abb6e"
    sha256 cellar: :any_skip_relocation, ventura:        "390bc35d6e6ba5d231498c8c6923749fdc2caf818f3fa805739db48784ff0638"
    sha256 cellar: :any_skip_relocation, monterey:       "7b2b8f4ce9d3d06c08a6df23e9b8e2a6c84e7aefd5e9fb5abaec3b9c0ec0fb62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b23b5efba9892fe123709252b8c29ea4554c3abc38a1e4da103528d1829f22b"
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