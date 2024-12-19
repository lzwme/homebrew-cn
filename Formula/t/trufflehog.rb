class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.87.1.tar.gz"
  sha256 "4ae09117f12bb74aed907ee3c88ecea632a20addbea28ba246df019299d927fd"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b8da36fbfa9b34525981db23e493dceff9dca3441e3c08e171f1896426a7f6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f03afa5903ede6f2da5e54700fad204f25864663abae56be16d7954fceb8207f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d653478e577bfb7ae847cc9b642d34379da9f184972ae3ea93af0a3de4483484"
    sha256 cellar: :any_skip_relocation, sonoma:        "d09d80d8db1d66da13429c55fb0df5f26ddb4843864827d66578f176162f3a75"
    sha256 cellar: :any_skip_relocation, ventura:       "46e4505a2ac3e1ea79463fd8368c4fbc000e7488d296ed3d52f2d4b060b704ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ca1657c76e550570300925f31461528eca259fab7aa1c334f2935b361c6cd93"
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