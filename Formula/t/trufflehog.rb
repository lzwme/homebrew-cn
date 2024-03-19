class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.70.2.tar.gz"
  sha256 "6f54e0e8c6e5b46805ec77b3c59beba21fe770d0078dc66adaf5c30f4c4a68a6"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07a1a78131276d0c9dedde91a65408fc7b666b4e466fe2af6c52c341de4abff8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd9f7713efacdfcc531db613e6ca482845ae2882730c5c91685707d528fa4b2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "600777db5b24f86f3f4102356d1cc4240f8bae5c28bfb2caddaadbf6f18fd38a"
    sha256 cellar: :any_skip_relocation, sonoma:         "79ef25ff07c6991c0c81319e538a796e29e1dd7d0c1a727f0665949b7448c6d2"
    sha256 cellar: :any_skip_relocation, ventura:        "d7c99390be8dcc848129eebb219262d9894aa2494a094975bb53c1bbf54fb29e"
    sha256 cellar: :any_skip_relocation, monterey:       "f7a5a75ba052f7685cfec925899b6fc2650d214601c6c73582093f86fb7d359e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fc00bd0bebbe7d0519d01adeec2dc709363bcf658cbb9835436af3d57f39093"
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