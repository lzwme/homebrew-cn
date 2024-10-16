class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.82.9.tar.gz"
  sha256 "fec874d99f7df9b37c80c0c2c67967a0ea7c49bdb7caaafa14c211653843e31d"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "251a7113916ba7c112af13c4508d912d0557fc16e7db9b36d24d7020a49b298a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa7e2b59c61ecfde19b9b1b779427752d167fffeabde9eb81785cc8a77b30d42"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a17f6629604c6eb0cad509f2071cebcd0fbe1a8f21ba9f9d2725f7873d3bfdcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf37a1ad18baa551fc83faacaa646e6d7eee800ff7d9e494698193c3d77972af"
    sha256 cellar: :any_skip_relocation, ventura:       "89c246336d5bb685d9ad29ef85879983e0efb9fa55b694a775c95685c076c21e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d23a4878ad0ad3aa5b039259e8b6915e91036d82ad1cbdadfe537d33f16676b"
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