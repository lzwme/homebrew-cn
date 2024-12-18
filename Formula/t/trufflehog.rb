class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.87.0.tar.gz"
  sha256 "84a5a3a2ca8ff21ae589d99d0fb4d168beed6372d39c8c631846ab9625988485"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ef9356373ed6191e997b6c3549e0434fda14781f154a8144dbadf47345829c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24dc1a4b6b3b58a2ecf290418f5f36d8cd3e05e1cd5065940858067a32efe9b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d57fbf9fef57d3700dfb2d45436ddc14295bf2238807699ea0a286ee60f26bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "10a3f8b24c1269fdafbc3d27c45ee027e5986a9bb2cac285b0707f75b7b38453"
    sha256 cellar: :any_skip_relocation, ventura:       "909bc5040197e448e04dd0ad4254d45038572a3795f4f183bdea9edfb45fe690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fa50ecbc25e38206e4607290d6f331f39300b92b3c49e60cf8179d3755e62b4"
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