class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.11.tar.gz"
  sha256 "8b329b6dc9b6213dd578f7787149f6de5b946aaec5c8b0bb1cc526c95cc3f4b6"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9beb28c5f80e0e1e17e209f4bf0feac4df7b377ac051bfe118ea60360578ebdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61168c5d2855665bc6cba24039546e97cbd85b4720c79338db7189cc819e313d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65e8c5fe1508b3c9354f865a56c594f2e99f20612bba5fb696f7133940ad61b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "93c0db6e5269c6bfefb3e34f9532d3ab678251e0c3a7027876db635ea7ace8a8"
    sha256 cellar: :any_skip_relocation, ventura:       "91c6b7dcac322422223fc818ff6374b6594fde5771e02aecc86366a140e101b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97271c9f86451b5d5ead889bd6eab41caa0323c0aabf99c9fd90f5d141216357"
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